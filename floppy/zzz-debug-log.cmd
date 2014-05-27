@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if not defined PACKER_DEBUG echo off

if "%1" == "output_debug_info" goto output_debug_info

set PACKER_DEBUG_LOG=%TEMP%\packer_debug_%RANDOM%.log.txt

call "%~0" output_debug_info >"%PACKER_DEBUG_LOG%"

type "%PACKER_DEBUG_LOG%"

if not defined PACKER_LOG_DIR set PACKER_LOG_DIR=z:\c\packer_logs

set PACKER_LOG_PATH=%PACKER_LOG_DIR %\%COMPUTERNAME%
if not exist "%PACKER_LOG_PATH%" mkdir "%PACKER_LOG_PATH%"
if not exist "%PACKER_LOG_PATH%" echo ==^> ERROR: Unable to create directory "%PACKER_LOG_PATH%" & goto exit1

xcopy /c /e /h /i /k /r /y "%TEMP%\*.log.txt" "%PACKER_LOG_PATH%\"
xcopy /c /e /h /i /k /r /y "%TEMP%" "%PACKER_LOG_PATH%\temp\"
xcopy /c /e /h /i /k /r /y "%SystemRoot%\TEMP" "%PACKER_LOG_PATH%\windows_temp\"

goto exit0

:output_debug_info

echo on

@echo %date% %time%: %0 log started

for %%i in (a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:) do if exist "%%~i" dir "%%~i\"

@echo ==============================

dir "%ProgramFiles%"

@echo ==============================

if defined ProgramFiles(x86) dir "%ProgramFiles(x86)%"

@echo ==============================

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

for %%i in ("%USERPROFILE%\AppData\Local\Temp" "%SystemRoot%\TEMP") do if exist "%%~i" dir /s "%%~i\"

@echo ==============================

:exit0

ver>nul

goto :exit

:exit1

verify other 2>nul

:exit

echo ==^> Script exiting with errorlevel %ERRORLEVEL%
exit /b %ERRORLEVEL%
