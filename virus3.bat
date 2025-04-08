@echo off
setlocal enabledelayedexpansion

:: === Config ===
set "ALLOWED_MAC=00-1A-2B-3C-4D-5E"
set "ENCRYPTED_FILE=repo_encrypted.bin"
set "DECRYPTED_FILE=repo.zip"
set "PASSWORD=StrongPassword"

:: === Get MAC address ===
for /f "tokens=1 delims= " %%A in ('getmac ^| findstr /v "Disconnected"') do (
    set "CURRENT_MAC=%%A"
    goto :checkmac
)

:checkmac
echo Detected MAC: %CURRENT_MAC%

if /i "%CURRENT_MAC%"=="%ALLOWED_MAC%" (
    echo MAC address authorized. Proceeding with decryption...
    goto :decrypt
) else (
    echo Unauthorized device. Extraction aborted.
    pause
    exit /b
)

:decrypt
:: Decrypt the encrypted file using openssl
openssl enc -aes-256-cbc -d -in %ENCRYPTED_FILE% -out %DECRYPTED_FILE% -k %PASSWORD%

if errorlevel 1 (
    echo Decryption failed!
    pause
    exit /b
)

echo Decryption successful. Extracting...

:: Extract the zip using PowerShell
powershell -Command "Expand-Archive -Path '%DECRYPTED_FILE%' -DestinationPath './extracted'"

if errorlevel 1 (
    echo Extraction failed!
    pause
    exit /b
)

echo Extraction completed successfully!
pause
exit /b
