@echo off
title  MAC-Protected Folder Access
color 0A

:: STEP 1: Set your trusted MAC address and folder path
set "APPROVED_MAC=0A-00-27-00-00-11"
set "FOLDER=C:\Users\Yuvraj\OneDrive\Desktop\secrete folder"

:: STEP 2: Create folder if it doesn't exist
if not exist "%FOLDER%" (
    echo Creating the secret folder...
    mkdir "%FOLDER%"
)

:: STEP 3: Get current MAC address (first adapter only)
for /f "tokens=1 delims= " %%A in ('getmac /fo table /nh') do (
    set "CURRENT_MAC=%%A"
    goto check
)

:check
cls
echo ========================================
echo  Checking your system MAC address...
echo ----------------------------------------
echo Your MAC Address     : %CURRENT_MAC%
echo Allowed MAC Address  : %APPROVED_MAC%
echo ========================================
echo.

:: STEP 4: Compare MAC and decide what to do
if /I "%CURRENT_MAC%"=="%APPROVED_MAC%" (
    echo Access Granted! Opening folder...
    explorer "%FOLDER%"
) else (
    echo Access Denied! Wrong MAC Address.
    echo Encrypting folder for security...
    cipher /E /S:"%FOLDER%"
    echo Done.
)

pause
exit