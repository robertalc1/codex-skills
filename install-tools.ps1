[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if (-not (Get-Command npm.cmd -ErrorAction SilentlyContinue)) { throw 'Install Node.js LTS and reopen the terminal.' }
& npm.cmd install -g '@playwright/cli@0.1.22' 'rea-agents@6.5.0' '--allow-scripts=frida'
if ($LASTEXITCODE -ne 0) { throw 'npm installation failed.' }
$venv = Join-Path ([Environment]::GetFolderPath('UserProfile')) '.local\share\codex-skills\markitdown-venv'
$mdPython = Join-Path $venv 'Scripts\python.exe'
$uv = Get-Command uv.exe -ErrorAction SilentlyContinue
if (-not (Test-Path -LiteralPath $mdPython)) {
    if ($uv) {
        & $uv.Source venv --python 3.13 $venv
    } else {
        $python = Get-Command python.exe -ErrorAction SilentlyContinue
        if (-not $python) { throw 'Install Python 3.10-3.14 or uv, then rerun install-tools.cmd.' }
        & $python.Source -m venv $venv
    }
    if ($LASTEXITCODE -ne 0) { throw 'Could not create the isolated MarkItDown environment.' }
}
$manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'sources.lock.json') -Raw | ConvertFrom-Json
$source = $manifest.sources | Where-Object id -eq 'markitdown'
if ($source.commit -notmatch '^[0-9a-f]{40}$') { throw 'Invalid MarkItDown source pin.' }
$package = 'markitdown[all] @ git+https://github.com/microsoft/markitdown.git@' + $source.commit + '#subdirectory=packages/markitdown'
if ($uv) { & $uv.Source pip install --python $mdPython --upgrade $package }
else { & $mdPython -m pip install --upgrade $package }
if ($LASTEXITCODE -ne 0) { throw 'MarkItDown installation failed.' }
& playwright-cli.cmd --version
if ($LASTEXITCODE -ne 0) { throw 'Playwright CLI verification failed.' }
& rea.cmd --version
if ($LASTEXITCODE -ne 0) { throw 'REA CLI verification failed.' }
& $mdPython -m markitdown --version
if ($LASTEXITCODE -ne 0) { throw 'MarkItDown verification failed.' }
Write-Host "MarkItDown Python: $mdPython"
Write-Host 'REA CLI is installed. MCP registration and native analysis engines are configured separately when needed.'
