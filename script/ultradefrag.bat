@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if not defined PACKER_DEBUG echo off

if not defined ULTRADEFRAG_32_URL set ULTRADEFRAG_32_URL=http://downloads.sourceforge.net/ultradefrag/ultradefrag-portable-6.0.2.bin.amd64.zip
if not defined ULTRADEFRAG_64_URL set ULTRADEFRAG_64_URL=http://downloads.sourceforge.net/ultradefrag/ultradefrag-portable-6.0.2.bin.i386.zip

if exist "%SystemDrive%\Program Files (x86)" (
  set ULTRADEFRAG_URL=%ULTRADEFRAG_64_URL%
) else (
  set ULTRADEFRAG_URL=%ULTRADEFRAG_32_URL%
)

for %%i in ("%ULTRADEFRAG_URL%") do set ULTRADEFRAG_ZIP=%%~nxi
set ULTRADEFRAG_DIR=%TEMP%\ultradefrag
set ULTRADEFRAG_PATH=%ULTRADEFRAG_DIR%\%ULTRADEFRAG_ZIP%

echo ==^> Creating "%ULTRADEFRAG_DIR%"
mkdir "%ULTRADEFRAG_DIR%"
pushd "%ULTRADEFRAG_DIR%"

if exist "%SystemRoot%\_download.cmd" (
  call "%SystemRoot%\_download.cmd" "%ULTRADEFRAG_URL%" "%ULTRADEFRAG_PATH%"
) else (
  echo ==^> Downloadling "%ULTRADEFRAG_URL%" to "%ULTRADEFRAG_PATH%"
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%ULTRADEFRAG_URL%', '%ULTRADEFRAG_PATH%')" <NUL
)
if not exist "%ULTRADEFRAG_PATH%" goto exit1

if not exist a:\unzip.vbs echo ==^> ERROR: File not found: a:\unzip.vbs & goto exit1

echo ==^> Unzipping "%ULTRADEFRAG_PATH%" to "%ULTRADEFRAG_DIR%"
cscript a:\unzip.vbs //b "%ULTRADEFRAG_PATH%" "%ULTRADEFRAG_DIR%"

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: cscript a:\unzip.vbs //b "%ULTRADEFRAG_PATH%" "%ULTRADEFRAG_DIR%"
ver>nul

set ULTRADEFRAG_UNZIP_DIR=

for /d %%i in ("%ULTRADEFRAG_DIR%\*.*") do set ULTRADEFRAG_UNZIP_DIR=%%~i

if not defined ULTRADEFRAG_UNZIP_DIR echo ==^> ERROR: Unzipping "%ULTRADEFRAG_PATH%" failed to create a directory in "%ULTRADEFRAG_DIR%" & goto exit1

if not exist "%ULTRADEFRAG_UNZIP_DIR%\udefrag.exe" echo ==^> ERROR: File not found: "%ULTRADEFRAG_UNZIP_DIR%\udefrag.exe" & goto exit1

echo ==^> Running UltraDefrag on %SystemDrive%
"%ULTRADEFRAG_UNZIP_DIR%\udefrag.exe" --optimize --repeat %SystemDrive%

@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%ULTRADEFRAG_UNZIP_DIR%\udefrag.exe" --optimize --repeat %SystemDrive%
ver>nul

popd

echo ==^> Removing "%ULTRADEFRAG_DIR%"
rmdir /q /s "%ULTRADEFRAG_DIR%"

:exit0

ver>nul

goto :exit

:exit1

verify other 2>nul

:exit

echo ==^> Script exiting with errorlevel %ERRORLEVEL%
exit /b %ERRORLEVEL%
