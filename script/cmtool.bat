@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if not defined PACKER_DEBUG echo off

if not defined CHEF_URL set CHEF_URL=https://www.getchef.com/chef/install.msi

if "%CM%" == "chef" goto chef
if "%CM%" == "nocm" goto nocm
if "%CM%" == "" echo ==^> ERROR: The required environment variable CM was not found & goto exit1

echo ==^> ERROR: Unknown value for environment variable CM: "%CM%"

goto exit1

::::::::::::
:chef
::::::::::::

set CHEF_MSI=chef-client-latest.msi
set CHEF_DIR=%TEMP%\chef
set CHEF_PATH=%CHEF_DIR%\%CHEF_MSI%
set FALLBACK_QUERY_STRING=?DownloadContext=PowerShell

echo ==^> Creating "%CHEF_DIR%"
mkdir "%CHEF_DIR%"
pushd "%CHEF_DIR%"

:: todo support CM_VERSION variable
if exist "%SystemRoot%\_download.cmd" (
  call "%SystemRoot%\_download.cmd" "%CHEF_URL%" "%CHEF_PATH%"
) else (
  echo ==^> Downloading %CHEF_URL% to %CHEF_PATH%
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%CHEF_URL%%FALLBACK_QUERY_STRING%', '%CHEF_PATH%')" <NUL
)
if not exist "%CHEF_PATH%" goto exit1

echo ==^> Installing Chef client %CM_VERSION%
msiexec /qb /i "%CHEF_PATH%"

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: msiexec /qb /i "%CHEF_PATH%"
ver>nul

goto exit0

::::::::::::
:nocm
::::::::::::

echo ==^> Building box without a configuration management tool

goto exit0

:exit1

verify other 2>nul

goto :exit

:exit0

ver>nul

:exit

echo ==^> Script exiting with errorlevel %ERRORLEVEL%
exit /b %ERRORLEVEL%
