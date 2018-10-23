@echo off
if exist 3rdparty\include (
	set vspring=3rdparty\include\vspring.h
) else (
	set vspring=vspring.h
)
echo //                                               > %vspring%
echo // vspring.h                                    >> %vspring%
echo // VSpring                                      >> %vspring%
echo //                                              >> %vspring%
echo // Created by kimbomm on 2018. 10. 16           >> %vspring%
echo // Copyright 2018 kimbomm. All rights reserved. >> %vspring%
echo //                                              >> %vspring%

setlocal EnableDelayedExpansion
echo. >> %vspring%
echo //static library >> %vspring%
echo #if _MSC_VER==1800 //Visual Studio 2013 >> %vspring%
::===================================================
echo #    if defined(_WIN64) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib120/x64/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib120/x64/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR /R %%E IN (3rdparty/staticlib120/x64/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    else //x86(Win32) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib120/x86/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib120/x86/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR /R %%E IN (3rdparty/staticlib120/x86/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    endif >> %vspring%
::===================================================
echo #elif _MSC_VER==1900 //Visual Studio 2015 >> %vspring%
::===================================================
echo #    if defined(_WIN64) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib140/x64/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib140/x64/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR /R %%E IN (3rdparty/staticlib140/x64/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    else //x86(Win32) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib140/x86/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib140/x86/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR /R %%E IN (3rdparty/staticlib140/x86/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    endif >> %vspring%
::===================================================
echo #elif _MSC_VER>1900 //Visual Studio 2017 >> %vspring%
::===================================================
echo #    if defined(_WIN64) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib141/x64/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib141/x64/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR /R %%E IN (3rdparty/staticlib141/x64/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    else //x86(Win32) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib141/x86/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        if defined(_DEBUG) >> %vspring%
FOR /R %%E IN (3rdparty/staticlib141/x86/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        else >> %vspring%
FOR /R %%E IN (3rdparty/staticlib141/x86/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #        endif //defined(_DEBUG) >> %vspring%
echo #    endif >> %vspring%
::===================================================
echo #endif //_MSC_VER >> %vspring%
echo. >> %vspring%
echo //shared library >> %vspring%
echo #if defined(_WIN64) >> %vspring%
FOR /R %%E IN (3rdparty/lib/x64/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    if defined(_DEBUG) >> %vspring%
FOR /R %%E IN (3rdparty/lib/x64/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    else >> %vspring%
FOR /R %%E IN (3rdparty/lib/x64/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    endif //defined(_DEBUG) >> %vspring%
echo #else //x86(Win32) >> %vspring%
FOR /R %%E IN (3rdparty/lib/x86/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    if defined(_DEBUG) >> %vspring%
FOR /R %%E IN (3rdparty/lib/x86/Debug/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #   else >> %vspring%
FOR /R %%E IN (3rdparty/lib/x86/Release/*.lib) DO echo #pragma comment(lib,"%%~nxE") >> %vspring%
echo #    endif //defined(_DEBUG) >> %vspring%
echo #endif >> %vspring%
endlocal