@echo off
setlocal
pushd "%~dp0" || exit /b 1
git diff --quiet
if errorlevel 1 goto dirty
git diff --cached --quiet
if errorlevel 1 goto dirty
git pull --ff-only
if errorlevel 1 goto failed
call "%~dp0setup.cmd"
set "skillUpdateExit=%errorlevel%"
popd
exit /b %skillUpdateExit%
:dirty
echo Local changes detected. Commit or preserve them before updating.
popd
exit /b 1
:failed
echo Update failed. Existing skills were preserved.
popd
exit /b 1
