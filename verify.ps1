[CmdletBinding()]
param([string]$UpstreamRoot, [switch]$TestSetup)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $root 'sources.lock.json') -Raw | ConvertFrom-Json
$directories = @{}
$names = @{}
$filesChecked = 0
foreach ($skill in $manifest.skills) {
    if ($directories.ContainsKey($skill.directory)) { throw "Duplicate directory: $($skill.directory)" }
    $directories[$skill.directory] = $true
    $folder = Join-Path (Join-Path $root 'skills') $skill.directory
    $text = Get-Content -LiteralPath (Join-Path $folder 'SKILL.md') -Raw
    if ($text -notmatch '(?s)^---\r?\n.+?\r?\n---') { throw "Missing frontmatter: $folder" }
    if ($text -notmatch '(?m)^name:\s*(.+)$') { throw "Missing name: $folder" }
    $name = $Matches[1].Trim().Trim('"', "'")
    if ($names.ContainsKey($name)) { throw "Duplicate invocation name: $name" }
    $names[$name] = $true
    if ($text -notmatch '(?m)^description:\s*\S') { throw "Missing description: $folder" }
    if (-not $UpstreamRoot -or $skill.source -eq 'bsgis-design' -or ($skill.PSObject.Properties['kind'] -and $skill.kind -eq 'adapter')) { continue }
    $upstream = Join-Path (Join-Path $UpstreamRoot $skill.source) $skill.upstreamPath
    $originals = @(Get-ChildItem -LiteralPath $upstream -File -Recurse)
    $vendored = @(Get-ChildItem -LiteralPath $folder -File -Recurse)
    if ($originals.Count -ne $vendored.Count) { throw "Snapshot file count differs: $folder" }
    foreach ($file in $originals) {
        $relative = $file.FullName.Substring($upstream.TrimEnd('\').Length + 1)
        $copy = Join-Path $folder $relative
        if ((Get-FileHash -LiteralPath $file.FullName).Hash -ne (Get-FileHash -LiteralPath $copy).Hash) { throw "Snapshot differs: $copy" }
        $filesChecked++
    }
}
if ($TestSetup) {
    $testRoot = Join-Path ([IO.Path]::GetTempPath()) ('codex-skills-verify-' + [guid]::NewGuid().ToString('N'))
    $conflictRoot = Join-Path $testRoot 'conflicts'
    $first = [string]$manifest.skills[0].directory
    New-Item -ItemType Directory -Path (Join-Path $conflictRoot $first) -Force | Out-Null
    $sentinel = Join-Path (Join-Path $conflictRoot $first) 'preserved.txt'
    Set-Content -LiteralPath $sentinel -Value 'preserved'
    $failed = $false
    try { & (Join-Path $root 'setup.ps1') -SkillsRoot $conflictRoot } catch { $failed = $true }
    if (-not $failed -or -not (Test-Path -LiteralPath $sentinel)) { throw 'Conflict preflight did not preserve the existing skill.' }
    if (@(Get-ChildItem -LiteralPath $conflictRoot).Count -ne 1) { throw 'Conflict preflight created partial junctions.' }
    & (Join-Path $root 'setup.ps1') -SkillsRoot $conflictRoot -BackupExisting
    & (Join-Path $root 'setup.ps1') -SkillsRoot $conflictRoot
    foreach ($skill in $manifest.skills) {
        $installed = Get-Item -LiteralPath (Join-Path $conflictRoot $skill.directory)
        if ($installed.LinkType -ne 'Junction' -or -not (Test-Path -LiteralPath (Join-Path $installed.FullName 'SKILL.md'))) { throw "Invalid installed skill: $($skill.directory)" }
    }
    Write-Host "Setup conflict, backup and idempotency checks passed. Test junctions: $conflictRoot"
}
Write-Host "Verified $($directories.Count) skills, $($manifest.sources.Count) sources, $filesChecked byte-identical upstream files."
