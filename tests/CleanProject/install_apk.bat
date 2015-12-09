::@echo off
pushd %~dp0
set LOCAL_PATH=%~dp0

adb uninstall com.pascode.CleanProject
adb install "%LOCAL_PATH%build\bin\CleanProject.apk"

pause
popd