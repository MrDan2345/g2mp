::@echo off
pushd %~dp0
set LOCAL_PATH=%~dp0
set APP_NAME=CleanProject

call "C:\Program Files\Java\jdk1.7.0_25\bin\apt.exe"^
 p^
 -v^
 -f^
 -M %LOCAL_PATH%build\AndroidManifest.xml^
 -F %LOCAL_PATH%build\bin\%APP_NAME%.ap_^
 -I D:\android\sdk\platforms\android-8\android.jar^
 -S res^
 -m^
 -Jgen^
 -Jraw

pause
 
call "C:\Program Files\Java\jdk1.7.0_25\bin\javac.exe"^
 -verbose^
 -d %LOCAL_PATH%build\obj^
 -cp %LOCAL_PATH%build\obj;D:\android\sdk\platforms\android-8\android.jar^
 -s %LOCAL_PATH%build\obj^
 %LOCAL_PATH%build\src\com\pascode\%APP_NAME%\%APP_NAME%.java
 
call "C:\Program Files\Java\jdk1.7.0_25\bin\java.exe"^
 -Djava.ext.dirs=D:\android\sdk\build-tools\android-4.4\lib^
 -jar D:\android\sdk\build-tools\android-4.4\lib\dx.jar^
 --dex^
 --verbose^
 --output=%LOCAL_PATH%build\bin\classes.dex %LOCAL_PATH%build\bin\classes

del %LOCAL_PATH%build\bin\%APP_NAME%-unsigned.apk

call "C:\Program Files\Java\jdk1.7.0_25\bin\java.exe"^
 -classpath D:\android\sdk\tools\lib\sdklib.jar com.android.sdklib.build.ApkBuilderMain %LOCAL_PATH%build\bin\%APP_NAME%-unsigned.apk^
 -v^
 -u^
 -z^
 %LOCAL_PATH%build\bin\%APP_NAME%.ap_^
 -f %LOCAL_PATH%build\bin\classes.dex
 
pause
popd