@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if not defined PACKER_DEBUG echo off

echo on

if "%1" == "output_debug_info" goto output_debug_info

set PACKER_DEBUG_LOG=%TEMP%\packer_debug_%RANDOM%.log.txt

call "%~0" output_debug_info >"%PACKER_DEBUG_LOG%"

type "%PACKER_DEBUG_LOG%"

if not exist z:\c goto exit0

set PACKER_HOST_TMPDIR=z:\c\packer_build_logs\%COMPUTERNAME%
mkdir "%PACKER_HOST_TMPDIR%"
xcopy /c /e /h /i /k /r /y "%TEMP%\*.log.txt" "%PACKER_HOST_TMPDIR%\"
xcopy /c /e /h /i /k /r /y "%TEMP%" "%PACKER_HOST_TMPDIR%\temp\"
xcopy /c /e /h /i /k /r /y "%SystemRoot%\TEMP" "%PACKER_HOST_TMPDIR%\windows_temp\"

goto exit0

:output_debug_info

@echo %date% %time%: %0 log started

for %%i in (a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:) do if exist "%%~i" cd "%%~i"

@echo ==============================

for %%i in (a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:) do if exist "%%~i" dir "%%~i\"

@echo ==============================

:: for %%i in ("%ProgramFiles%\*.*") do if exist "%%~i" dir "%%~i"

:: if defined ProgramFiles(x86) for %%i in ("%ProgramFiles(x86)%\*.*") do if exist "%%~i" dir "%%~i"

for /r %SystemDrive%\ %%i in (*.iso) do echo %%i

@echo ==============================

for /r "%USERPROFILE%\.ssh" %%i in (*.*) do type "%%~i"

@echo ==============================

set | sort

@echo ==============================

ipconfig

@echo ==============================

systeminfo

@echo ==============================

net start

@echo ==============================

for %%i in (%PACKER_SERVICES%) do (
  sc query %%i
)

:: echo ==^> reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s:

:: reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP" /s

@echo ==============================

for %%i in ("%USERPROFILE%\AppData\Local\Temp" "%SystemRoot%\TEMP") do if exist "%%~i" dir /s "%%~i"

@echo ==============================

:exit0

ver>nul

goto :exit

:exit1

verify other 2>nul

:exit

echo ==^> Script exiting with errorlevel %ERRORLEVEL%
exit /b %ERRORLEVEL%
