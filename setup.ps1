[CmdletBinding()]
param(
    [string]$SkillsRoot = (Join-Path ([Environment]::GetFolderPath('UserProfile')) '.agents\skills'),
    [switch]$BackupExisting
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Junctions keep updates in one checkout. Never replace existing skills.
$repositoryRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$destinationRoot = [IO.Path]::GetFullPath($SkillsRoot)
$manifest = Get-Content -LiteralPath (Join-Path $repositoryRoot 'sources.lock.json') -Raw | ConvertFrom-Json
$items = @($manifest.skills)
if ($items.Count -eq 0) { throw 'No skills are listed in sources.lock.json.' }
$plan = @()
$seen = @{}
$backupRoot = Join-Path ([Environment]::GetFolderPath('UserProfile')) ('.local\share\codex-skill-backups\setup-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
foreach ($skill in $items) {
    $name = [string]$skill.directory
    if ($name -notmatch '^[a-z0-9][a-z0-9-]*$' -or $seen.ContainsKey($name)) {
        throw "Invalid or duplicate skill directory: $name"
    }
    $seen[$name] = $true
    $sourcePath = Join-Path (Join-Path $repositoryRoot 'skills') $name
    $targetPath = Join-Path $destinationRoot $name
    if (-not (Test-Path -LiteralPath (Join-Path $sourcePath 'SKILL.md') -PathType Leaf)) {
        throw "Missing SKILL.md: $sourcePath"
    }
    if ($sourcePath.TrimEnd('\') -ieq $targetPath.TrimEnd('\')) {
        throw 'Clone this repository outside the global skills directory.'
    }
    $existing = Get-Item -LiteralPath $targetPath -Force -ErrorAction SilentlyContinue
    $exists = $null -ne $existing
    $needsBackup = $false
    if ($exists) {
        $isLink = $existing.PSObject.Properties['LinkType'] -and $existing.LinkType -eq 'Junction'
        $sameTarget = $false
        if ($isLink) {
            $linkTarget = [IO.Path]::GetFullPath([string]@($existing.Target)[0])
            $sameTarget = $linkTarget.TrimEnd('\') -ieq $sourcePath.TrimEnd('\')
        }
        if (-not $sameTarget -and -not $BackupExisting) {
            throw "Conflict at $targetPath. Nothing has been replaced. Keep or relocate the existing skill before trying again."
        }
        $needsBackup = -not $sameTarget
    }
    $plan += [pscustomobject]@{ Name=$name; Source=$sourcePath; Destination=$targetPath; Exists=$exists; NeedsBackup=$needsBackup }
}
# Check every conflict before creating junctions.
New-Item -ItemType Directory -Path $destinationRoot -Force | Out-Null
$added = 0
foreach ($entry in $plan) {
    if ($entry.NeedsBackup) {
        New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
        $saved = Join-Path $backupRoot $entry.Name
        Move-Item -LiteralPath $entry.Destination -Destination $saved
        try { New-Item -ItemType Junction -Path $entry.Destination -Target $entry.Source | Out-Null }
        catch { Move-Item -LiteralPath $saved -Destination $entry.Destination; throw }
        $added++
    } elseif (-not $entry.Exists) {
        New-Item -ItemType Junction -Path $entry.Destination -Target $entry.Source | Out-Null
        $added++
    }
}
Write-Host "$($plan.Count) global skills ready; $added new junctions."
Write-Host "Location: $destinationRoot"
if (@($plan | Where-Object NeedsBackup).Count) { Write-Host "Previous skills preserved: $backupRoot" }
Write-Host 'In Codex, run /skills or start a new session.'
Write-Host 'Playwright CLI is a separate dependency: run install-tools.cmd once if needed.'
