@echo off
setlocal
where node.exe >nul 2>nul
if errorlevel 1 (
  echo Install Node.js LTS first, then reopen the terminal.
  exit /b 1
)
call npm.cmd install -g @playwright/cli@0.1.21
if errorlevel 1 exit /b 1
call playwright-cli.cmd --version
exit /b %errorlevel%
