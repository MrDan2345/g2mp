::@echo off
pushd %~dp0
set LOCAL_PATH=%~dp0

::call %JAVA_BIN_PATH%keytool.exe --help

call "C:\Program Files\Java\jdk1.7.0_25\bin\keytool.exe" -genkey -v -keystore %LOCAL_PATH%bin\debug_key.keystore -alias debug_key -keyalg RSA -validity 10000

pause
popd