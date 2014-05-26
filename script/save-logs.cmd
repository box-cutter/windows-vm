@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if not defined PACKER_DEBUG echo off

echo ==^> Saving installation logs

if not exist z:\c goto exit0

set PACKER_HOST_TMPDIR=z:\c\packer_build_logs\%COMPUTERNAME%
mkdir "%PACKER_HOST_TMPDIR%"
xcopy /c /i /y "%TEMP%\*.log.txt" "%PACKER_HOST_TMPDIR%"

:exit0

ver>nul

goto :exit

:exit1

verify other 2>nul

:exit

echo ==^> Script exiting with errorlevel %ERRORLEVEL%
exit /b %ERRORLEVEL%
