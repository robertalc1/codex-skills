[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$UpstreamRoot)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = [IO.Path]::GetFullPath($PSScriptRoot)
$upstreams = [IO.Path]::GetFullPath($UpstreamRoot)
$manifestPath = Join-Path $root 'sources.lock.json'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$newSources = @(
    @{id='rea'; repository='https://github.com/morluto/rea'; license='MIT'},
    @{id='marketing'; repository='https://github.com/coreyhaines31/marketingskills'; license='MIT'},
    @{id='ecc'; repository='https://github.com/affaan-m/ecc'; license='MIT'},
    @{id='adhd'; repository='https://github.com/ayghri/i-have-adhd'; license='MIT'},
    @{id='markitdown'; repository='https://github.com/microsoft/markitdown'; license='MIT'}
)
foreach ($source in $newSources) {
    if (-not @($manifest.sources | Where-Object id -eq $source.id).Count) {
        $manifest.sources += [pscustomobject]($source + @{commit=''})
    }
}
$newSkills = @(
    @{directory='reverse-engineer-anything'; source='rea'; upstreamPath='.agents/skills/reverse-engineer-anything'},
    @{directory='i-have-adhd'; source='adhd'; upstreamPath='skills/i-have-adhd'},
    @{directory='markitdown'; source='markitdown'; upstreamPath=''; kind='adapter'}
)
foreach ($spec in @(@{id='marketing'; path='skills'}, @{id='ecc'; path='.agents/skills'})) {
    $base = Join-Path (Join-Path $upstreams $spec.id) $spec.path
    foreach ($dir in Get-ChildItem -LiteralPath $base -Directory | Sort-Object Name) {
        if (Test-Path -LiteralPath (Join-Path $dir.FullName 'SKILL.md')) {
            $newSkills += @{directory=$dir.Name; source=$spec.id; upstreamPath=($spec.path + '/' + $dir.Name)}
        }
    }
}
foreach ($skill in $newSkills) {
    $existing = @($manifest.skills | Where-Object directory -eq $skill.directory)
    if ($existing.Count -and $existing[0].source -ne $skill.source) { throw "Conflicting skill: $($skill.directory)" }
    if (-not $existing.Count) { $manifest.skills += [pscustomobject]$skill }
}
# Validate every source and destination before touching vendored snapshots.
foreach ($source in $manifest.sources) {
    if ($source.PSObject.Properties['kind'] -and $source.kind -eq 'first-party') { continue }
    $checkout = Join-Path $upstreams $source.id
    $commit = git -C $checkout rev-parse HEAD
    if ($LASTEXITCODE -ne 0 -or $commit -notmatch '^[0-9a-f]{40}$') { throw "Invalid checkout: $checkout" }
    $source.commit = $commit
}
foreach ($skill in $manifest.skills) {
    if ($skill.directory -notmatch '^[a-z0-9][a-z0-9-]*$') { throw 'Invalid skill directory.' }
    if ($skill.source -eq 'bsgis-design' -or ($skill.PSObject.Properties['kind'] -and $skill.kind -eq 'adapter')) { continue }
    $path = Join-Path (Join-Path $upstreams $skill.source) $skill.upstreamPath
    if (-not (Test-Path -LiteralPath (Join-Path $path 'SKILL.md'))) { throw "Missing skill: $path" }
}
$backup = Join-Path ([Environment]::GetFolderPath('UserProfile')) ('.local\share\codex-skill-backups\import-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
foreach ($skill in $manifest.skills) {
    if ($skill.source -eq 'bsgis-design' -or ($skill.PSObject.Properties['kind'] -and $skill.kind -eq 'adapter')) { continue }
    $path = Join-Path (Join-Path $upstreams $skill.source) $skill.upstreamPath
    $target = Join-Path (Join-Path $root 'skills') $skill.directory
    if (Test-Path -LiteralPath $target) {
        New-Item -ItemType Directory -Path $backup -Force | Out-Null
        Move-Item -LiteralPath $target -Destination (Join-Path $backup $skill.directory)
    }
    Copy-Item -LiteralPath $path -Destination $target -Recurse
}
foreach ($source in $manifest.sources) {
    if ($source.PSObject.Properties['kind'] -and $source.kind -eq 'first-party') { continue }
    $checkout = Join-Path $upstreams $source.id
    $dest = Join-Path (Join-Path $root 'sources') $source.id
    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    foreach ($name in @('README.md','LICENSE','LICENSE.md','LICENSE.txt','NOTICE','THIRD_PARTY_NOTICES.md')) {
        $file = Join-Path $checkout $name
        if (Test-Path -LiteralPath $file -PathType Leaf) { Copy-Item -LiteralPath $file -Destination (Join-Path $dest $name) -Force }
    }
}
$manifest | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
$table = @('# Surse si versiuni', '', 'Snapshot-uri complete de skill-uri, fixate in `sources.lock.json`. Licentele originale sunt in `sources/`.', '', '| Sursa | Skill-uri | Licenta | Commit |', '|---|---:|---|---|')
foreach ($source in $manifest.sources) {
    $count = @($manifest.skills | Where-Object source -eq $source.id).Count
    $version = if ($source.PSObject.Properties['commit']) { $source.commit } else { 'first-party' }
    $table += "| [$($source.id)]($($source.repository)) | $count | $($source.license) | $version |"
}
$table += @('', 'ECC: setul Codex din `.agents/skills`; hook-urile, regulile globale, MCP-urile si celelalte integrari nu sunt activate la import.', 'REA: skill-ul principal reverse-engineer-anything; skill-urile de mentenanta ale proiectului REA nu sunt globale.', 'MarkItDown: biblioteca upstream si adaptor local; upstream nu publica SKILL.md.', '', '## Catalog', '')
foreach ($skill in $manifest.skills) { $table += "- [$($skill.directory)](skills/$($skill.directory)/SKILL.md) ($($skill.source))" }
$table | Set-Content -LiteralPath (Join-Path $root 'SOURCES.md') -Encoding UTF8
Write-Host "Imported $($manifest.skills.Count) skills from $($manifest.sources.Count) sources. Previous snapshots: $backup"
