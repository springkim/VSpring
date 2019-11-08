@echo off
call :AbsoluteDownloadCurl
call :Download7z
powershell "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $HTML=Invoke-WebRequest -Uri 'https://github.com/springkim/VSpring/releases/tag/archive' -UseBasicParsing;($HTML.Links.href)" > "%TEMP%\vsplib.txt"
powershell "get-content '%TEMP%\vsplib.txt' -ReadCount 1000 | foreach { $_ -match '.7z$' } | foreach { $_.substring(45,$_.length-48)}"
echo ============================================
set /p libname=Enter library to install : 


curlw -L "https://github.com/springkim/VSpring/releases/download/archive/%libname%.7z" -o "%TEMP%\%libname%.7z"
7z x "%TEMP%\%libname%.7z" -y -o".\"

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