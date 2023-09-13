@echo off
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'" #check script is ran as admin
    exit /b
)

echo y |PowerShell.exe Install-Module -name PSWindowsUpdate #install PSWindowsUpdate to enable us to use powershell to update windows

powershell Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted #required to enable loading of modules

powershell Import-Module -Name PSWindowsUpdate # load PSWindowsUpdate module

powershell Get-WindowsUpdate -AcceptAll -Install

echo y |PowerShell.exe Install-Module PSWindowsUpdate -force #install powershell windows update module

PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false #empty RecycleBin

START "" cleanmgr /verylowdisk /c #cleanup c

defrag c: -f

del %temp%\*.* /s /q #delete temporary files

PowerShell.exe -NoProfile SFC /scannow #scan and check system files, auto fixes issues

cipher /w:c: #delete unallocated

echo MAINTAINANCE COMPLETE REBOOTING TO COMPLETE WINDOWS UPDATES

timeout /t 10 

shutdown /r # reboot pc
