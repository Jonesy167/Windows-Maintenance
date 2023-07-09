
@echo off
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'" #check script is ran as admin
    exit /b
)
START "" cleanmgr /verylowdisk /c #cleanup c
echo.
echo.
PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false #empty RecycleBin
echo.
echo.
defrag c: -f
echo.
echo.
del %temp%\*.* /s /q #delete temp files
echo.
echo.
cipher /w:c: #delete unallocated
echo.
echo.
echo MAINTAINANCE COMPLETE
echo.
echo.
timeout /t 10 
exit