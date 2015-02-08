@ECHO OFF
@ECHO ==^> Running sysprep if requested in template file...
@if not defined sysprep ( 
  @ECHO ==^> No sysprep variable defined, exiting
  GOTO :eof
)
@echo %SYSPREP% | findstr /I "true"
@if errorlevel 1 (
  @ECHO ==^> Sysprep variable not set to true, exiting
  GOTO :eof
)
@ECHO ==^> Copying unattend.xml to sysprep directory
@COPY /Y A:\unattend.xml %WINDIR%\system32\sysprep
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: COPY command

@ECHO ==^> Running sysprep /oobe /generalize with unattend.xml file
@PUSHD %WINDIR%\system32\sysprep

:: Credit to http://stackoverflow.com/questions/4808847/how-to-compare-windows-versions-in-a-batch-script
@set Version=
@for /f "skip=1" %%v in ('wmic os get version') do if not defined Version set Version=%%v
@for /f "delims=. tokens=1-3" %%a in ("%Version%") do (
  @set Version.Major=%%a
  @set Version.Minor=%%b
  @set Version.Build=%%c
)
@ECHO ==^> Checking OS Version for sysprep command parameters
@if %Version.Major% GEQ 7 GOTO :modevm
@if %Version.Major% EQU 6 if %Version.Minor% GEQ 2 GOTO :modevm
@if %Version.Major% EQU 6 if %Version.Minor% LEQ 1 GOTO :generalize

:modevm
  @ECHO ==^> Windows 8 Kernel or higher found, supports /mode:vm
  sysprep.exe /oobe /generalize /mode:vm /quit
  GOTO :eof

:generalize
  @ECHO ==^> Windows 7 Kernel found
  sysprep.exe /oobe /generalize /quit
  GOTO :eof

:eof 
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: sysprep.exe
@exit /b %ERRORLEVEL%