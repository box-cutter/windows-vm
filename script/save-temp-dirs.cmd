@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if not defined PACKER_DEBUG echo off

if not exist z:\c goto exit0

echo ==^> Saving all installation files

set PACKER_HOST_TMPDIR=z:\c\packer_build_logs\%COMPUTERNAME%
mkdir "%PACKER_HOST_TMPDIR%"
xcopy /c /i /y "%TEMP%\*.log.txt" "%PACKER_HOST_TMPDIR%\"
xcopy /c /e /h /i /k /r /y "%TEMP%" "%PACKER_HOST_TMPDIR%\temp\"
xcopy /c /e /h /i /k /r /y "%SystemRoot%\TEMP" "%PACKER_HOST_TMPDIR%\windows_temp\"

goto exit0

:exit0

ver>nul

goto :exit

:exit1

verify other 2>nul

:exit

echo ==^> Script exiting with errorlevel %ERRORLEVEL%
exit /b %ERRORLEVEL%
