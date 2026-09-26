@echo off
setlocal
rem Execution policy override applies only to this installer process.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*
exit /b %errorlevel%
