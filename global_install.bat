@echo off
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Get admin permission...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    rem del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin

pushd "%CD%"
cd "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\"
dir /B > "%TEMP%\msvc2017path.txt"
set /p "msvcnum="<"%TEMP%\msvc2017path.txt"
echo "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\%msvcnum%\include\"> "%TEMP%\msvc2017include.txt"
set /p "dst_include_dir="<"%TEMP%\msvc2017include.txt"
echo C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\%msvcnum%\lib\x64\> "%TEMP%\msvc2017lib64.txt"
set /p "dst_lib_dir64="<"%TEMP%\msvc2017lib64.txt"
echo C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\%msvcnum%\lib\x86\> "%TEMP%\msvc2017lib86.txt"
set /p "dst_lib_dir86="<"%TEMP%\msvc2017lib86.txt"
set dst_stclib_dir64=staticlib141\x64
set dst_stclib_dir86=staticlib141\x86
popd

call :AbsoluteDownloadCurl
call :Download7z
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/springkim/VSpring/releases/tag/archive' -UseBasicParsing;($HTML.Links.href)" > "%TEMP%\vsplib.txt"
powershell "get-content '%TEMP%\vsplib.txt' -ReadCount 1000 | foreach { $_ -match '.7z$' } | foreach { $_.substring(45,$_.length-48)}"
echo ============================================
set /p libname=Enter library to install : 


curlw -L "https://github.com/springkim/VSpring/releases/download/archive/%libname%.7z" -o "%TEMP%\%libname%.7z"
call :GetFileSize "%TEMP%\%libname%.7z"
if %FILESIZE% lss 10 (
	echo Download failed.
	pause
	exit /b
)
7z x "%TEMP%\%libname%.7z" -y -o"%TEMP%\%libname%\"
if not exist "%temp%\%libname%" (
	echo Decompression failed.
	pause
	exit /b
)
cd %temp%\%libname%\
::include에 전부 #pragma comment 넣고
call :CurrDirList 3rdparty\include\ > include.txt
call :FillLinker
SETLOCAL EnableDelayedExpansion
for /F "tokens=*" %%A in (include.txt) do (
	type vspring.txt >> %%A
)
ENDLOCAL
xcopy /Y "3rdparty\include\*.*" %dst_include_dir% /e /h /k 2>&1 >NUL


::lib 정리하고
SETLOCAL EnableDelayedExpansion
for /R "3rdparty\lib\x64\" %%a in (*.*) do (
	copy /Y "%%a" "!dst_lib_dir64!%%~nxa" 2>&1 >NUL
)
for /R "3rdparty\lib\x86\" %%a in (*.*) do (
	copy /Y "%%a" "!dst_lib_dir86!%%~nxa" 2>&1 >NUL
)
for /R "3rdparty\%dst_stclib_dir64%\" %%a in (*.*) do (
	copy /Y "%%a" "!dst_lib_dir64!%%~nxa" 2>&1 >NUL
)
for /R "3rdparty\%dst_stclib_dir86%\" %%a in (*.*) do (
	copy /Y "%%a" "!dst_lib_dir86!%%~nxa" 2>&1 >NUL
)
::dll 정리하고
for /R "3rdparty\bin\x64\" %%a in (*.*) do (
	copy /Y "%%a" "C:\Windows\System32\%%~nxa" 2>&1 >NUL
)
for /R "3rdparty\bin\x86\" %%a in (*.*) do (
	copy /Y "%%a" "C:\Windows\SysWOW64\%%~nxa" 2>&1 >NUL
)

ENDLOCAL



echo ===================DONE=====================
pause
goto :EOF

:Download7z
if not exist "%WINDIR%\system32\7z.exe" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.exe" -o "%WINDIR%\system32\7z.exe"
if not exist "%WINDIR%\system32\7z.dll" curlw -L "https://github.com/springkim/WSpring/releases/download/bin/7z.dll" -o "%WINDIR%\system32\7z.dll"
exit /b

::Download CURL
:GetFileSize
if exist  %~1 set FILESIZE=%~z1
if not exist %~1 set FILESIZE=-1
exit /b
:AbsoluteDownloadCurl
:loop_adc1
call :GetFileSize "%SystemRoot%\System32\curlw.exe"
if %FILESIZE% neq 2070016 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/curl.exe','%WINDIR%\System32\curlw.exe')"
	goto :loop_adc1
)
:loop_adc2
call :GetFileSize "%SystemRoot%\System32\ca-bundle.crt"
if %FILESIZE% neq 261889 (
	powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://github.com/springkim/WSpring/releases/download/bin/ca-bundle.crt','%WINDIR%\System32\ca-bundle.crt')"
	goto :loop_adc2
)
exit /b
:CurrDirList
SETLOCAL EnableDelayedExpansion
pushd %cd%
cd %~1
set currdir=%cd%
FOR /R %%E IN (./*.*) DO (
	 echo %%E
)
ENDLOCAL
popd
exit /b
:FillLinker
set vspring=vspring.txt
echo. >> %vspring%
echo //static library >> %vspring%
echo #if _MSC_VER==1800 //Visual Studio 2013 >> %vspring%
::===================================================
echo #    if defined(_WIN64) >> %vspring%
FOR %%E IN (3rdparty/staticlib120/x64/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR %%E IN (3rdparty/staticlib120/x64/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR %%E IN (3rdparty/staticlib120/x64/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    else //x86(Win32) >> %vspring%
FOR %%E IN (3rdparty/staticlib120/x86/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR %%E IN (3rdparty/staticlib120/x86/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR %%E IN (3rdparty/staticlib120/x86/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    endif >> %vspring%
::===================================================
echo #elif _MSC_VER==1900 //Visual Studio 2015 >> %vspring%
::===================================================
echo #    if defined(_WIN64) >> %vspring%
FOR %%E IN (3rdparty/staticlib140/x64/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR %%E IN (3rdparty/staticlib140/x64/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR %%E IN (3rdparty/staticlib140/x64/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    else //x86(Win32) >> %vspring%
FOR %%E IN (3rdparty/staticlib140/x86/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR %%E IN (3rdparty/staticlib140/x86/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR %%E IN (3rdparty/staticlib140/x86/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    endif >> %vspring%
::===================================================
echo #elif _MSC_VER>1900 //Visual Studio 2017 >> %vspring%
::===================================================
echo #    if defined(_WIN64) >> %vspring%
FOR %%E IN (3rdparty/staticlib141/x64/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR %%E IN (3rdparty/staticlib141/x64/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR %%E IN (3rdparty/staticlib141/x64/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    else //x86(Win32) >> %vspring%
FOR %%E IN (3rdparty/staticlib141/x86/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR %%E IN (3rdparty/staticlib141/x86/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR %%E IN (3rdparty/staticlib141/x86/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    endif >> %vspring%
::===================================================
echo #endif //_MSC_VER >> %vspring%
echo. >> %vspring%
echo //shared library >> %vspring%
echo #if defined(_WIN64) >> %vspring%
FOR %%E IN (3rdparty/lib/x64/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    if defined(_DEBUG) >> %vspring%
FOR %%E IN (3rdparty/lib/x64/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    else >> %vspring%
FOR %%E IN (3rdparty/lib/x64/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    endif //defined(_DEBUG) >> %vspring%
echo #else //x86(Win32) >> %vspring%
FOR %%E IN (3rdparty/lib/x86/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    if defined(_DEBUG) >> %vspring%
FOR %%E IN (3rdparty/lib/x86/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #   else >> %vspring%
FOR %%E IN (3rdparty/lib/x86/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    endif //defined(_DEBUG) >> %vspring%
echo #endif >> %vspring%
exit /b 
