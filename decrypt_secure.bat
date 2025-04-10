@echo off
setlocal enabledelayedexpansion

:: === CONFIGURATION ===
set "ALLOWED_MAC=00-11-22-33-44-55"  :: <-- Replace with your MAC
set "ZIP_FILE=secure_data.7z"
set "ZIP_PASSWORD=MyStrongPassword"  :: <-- Replace with strong password
set "EXTRACT_TO=SecureFolder"
set "SEVENZIP_PATH=Downloads"
:: ======================

echo [INFO] Checking machine MAC address...

:: Get first MAC address
for /f "tokens=1 delims=," %%a in ('getmac /fo csv /nh') do (
    set "CURRENT_MAC=%%~a"
    goto :validate
)

:validate
echo [INFO] Detected MAC: %CURRENT_MAC%
echo [INFO] Allowed MAC : %ALLOWED_MAC%

if /i "%CURRENT_MAC%"=="%ALLOWED_MAC%" (
    echo [OK] Authorized device.
    if exist "%SEVENZIP_PATH%" (
        "%SEVENZIP_PATH%" x "%ZIP_FILE%" -p%ZIP_PASSWORD% -o"%EXTRACT_TO%" -y
        if %errorlevel%==0 (
            echo [DONE] Extraction complete → "%EXTRACT_TO%"
        ) else (
            echo [ERROR] Extraction failed.
        )
    ) else (
        echo [ERROR] 7-Zip not found: %SEVENZIP_PATH%
    )
) else (
    echo [DENIED] Unauthorized MAC address.
    pause
    exit /b 1
)
pause
