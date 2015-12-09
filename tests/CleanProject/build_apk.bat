::@echo off
pushd %~dp0
set LOCAL_PATH=%~dp0
set APP_NAME=CleanProject
set ASDK_PATH=D:\android\sdk\
set ANDK_PATH=D:\android\ndk\

del %LOCAL_PATH%build\bin\%APP_NAME%-unsigned.apk
del %LOCAL_PATH%build\bin\%APP_NAME%-unaligned.apk
del %LOCAL_PATH%build\bin\%APP_NAME%.ap_
del %LOCAL_PATH%build\bin\%APP_NAME%.apk

call "D:\android\sdk\build-tools\20.0.0\aapt.exe"^
 p^
 -v^
 -f^
 -M "%LOCAL_PATH%build\AndroidManifest.xml"^
 -F "%LOCAL_PATH%build\bin\%APP_NAME%.ap_"^
 -I "%ASDK_PATH%platforms\android-8\android.jar"^
 -S "%LOCAL_PATH%build\res"^
 -m^
 -J "%LOCAL_PATH%build\gen" "%LOCAL_PATH%build\raw"
 
call "C:\Program Files\Java\jdk1.7.0_25\bin\javac.exe"^
 -verbose^
 -encoding UTF8^
 -classpath "%ASDK_PATH%platforms\android-8\android.jar"^
 -d %LOCAL_PATH%build\bin\classes^
 %LOCAL_PATH%build\src\com\pascode\%APP_NAME%\%APP_NAME%.java
 
call "C:\Program Files\Java\jdk1.7.0_25\bin\java.exe"^
 -Djava.ext.dirs=%ASDK_PATH%build-tools\20.0.0\lib^
 -jar %ASDK_PATH%build-tools\20.0.0\lib\dx.jar^
 --dex^
 --verbose^
 --output=%LOCAL_PATH%build\bin\classes.dex %LOCAL_PATH%build\bin\classes

call "C:\Program Files\Java\jdk1.7.0_25\bin\java.exe"^
 -classpath %ASDK_PATH%tools\lib\sdklib.jar com.android.sdklib.build.ApkBuilderMain %LOCAL_PATH%build\bin\%APP_NAME%-unsigned.apk^
 -v^
 -u^
 -z^
 %LOCAL_PATH%build\bin\%APP_NAME%.ap_^
 -f %LOCAL_PATH%build\bin\classes.dex
 
call "C:\Program Files\Java\jdk1.7.0_25\bin\keytool.exe"^
 -genkey^
 -v^
 -keystore "%LOCAL_PATH%build\bin\debug_key.keystore"^
 -alias debug_key^
 -keyalg RSA^
 -validity 10000^
 -dname "cn=Fname Lname, ou=engineering, o=company, c=TH"^
 -storepass mypass^
 -keypass mypass

call "C:\Program Files\Java\jdk1.7.0_25\bin\jarsigner.exe"^
 -verbose^
 -sigalg MD5withRSA^
 -digestalg SHA1^
 -keystore "%LOCAL_PATH%build\bin\debug_key.keystore"^
 -keypass mypass^
 -storepass mypass^
 -signedjar "%LOCAL_PATH%build\bin\%APP_NAME%-unaligned.apk" "%LOCAL_PATH%build\bin\%APP_NAME%-unsigned.apk" debug_key
 
call "%ASDK_PATH%build-tools\20.0.0\zipalign.exe"^
 -v 4 "%LOCAL_PATH%build\bin\%APP_NAME%-unaligned.apk" "%LOCAL_PATH%build\bin\%APP_NAME%.apk"
 
pause
popd