@echo off
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'" #check script is ran as admin
    exit /b
)
echo.
echo Do you wish to shutdown on completion of this maintainance? enter Y for yes or N for no
echo.
set /p input= 

if "%input%"=="y" (goto start1)
if "%input%"=="n" (goto start1)
if "%input%"=="Y" (goto start1)
if "%input%"=="N" (goto start1)

echo.
echo INVALID INPUT - YOU MUST ENTER Y OR N
echo.
timeout /t 5
exit

:start1 

echo.
echo WORKING - THIS WILL TAKE APPROX 30 MINS.
timeout /t 5
echo.

echo y |PowerShell.exe Install-Module -name PSWindowsUpdate #install PSWindowsUpdate to enable us to use powershell to update windows

powershell Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted #required to enable loading of modules

echo y |PowerShell.exe Install-Module PSWindowsUpdate -force #install powershell windows update module

powershell Import-Module -Name PSWindowsUpdate # load PSWindowsUpdate module

powershell Get-WindowsUpdate -AcceptAll -Install

PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false #empty RecycleBin

START "" cleanmgr /verylowdisk /c #cleanup 

defrag c: -f

del %temp%\*.* /s /q #delete temporary files

PowerShell.exe -NoProfile SFC /scannow #scan and check system files, auto fixes issues

cipher /w:c: #delete unallocated

echo.
echo MAINTAINANCE COMPLETE 
echo.
timeout /t 10 

if "%input%"=="y" (echo SHUTING DOWN NOW)
if "%input%"=="Y" (echo SHUTING DOWN NOW)

timeout /t 5 

if "%input%"=="y" (shutdown /s)
if "%input%"=="Y" (shutdown /s)

EXIT /B
