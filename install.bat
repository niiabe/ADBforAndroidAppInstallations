

:start
@echo off

@echo off
setlocal
rem Check for ADB
where adb >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: ADB is not found. Make sure it's installed and in your system PATH.
    goto :end
)

rem Get connected devices
adb devices | findstr /C:"device" >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: No ADB devices found. Please connect a device and enable USB debugging.
    goto :end
)

echo ================================================
echo Android Device Configuration and APK Installer
echo ================================================
echo.

rem === Set display timeout to 30 minutes (1,800,000 ms) ===
echo [1/4] Setting display timeout to 30 minutes...
adb shell settings put system screen_off_timeout 1800000
if %errorlevel% equ 0 (
    echo SUCCESS: Display timeout set to 30 minutes
) else (
    echo WARNING: Failed to set display timeout
)
echo.

rem === Attempt to remove security screen lock (multiple methods) ===
echo [2/4] Attempting to remove screen lock...

rem Method 1: Clear lock settings (works on some devices)
echo Trying method 1: locksettings clear...
adb shell locksettings clear
if %errorlevel% equ 0 (
    echo Method 1: Command executed successfully
) else (
    echo Method 1: Command failed or not supported
)

rem Method 2: Set lock type to none via settings
echo Trying method 2: Setting lock screen to none...
adb shell settings put secure lockscreen.disabled 1
adb shell settings put system lockscreen.disabled 1

rem Method 3: Clear lock pattern/password databases (requires root)
echo Trying method 3: Clearing lock databases...
adb shell rm /data/system/gesture.key 2>nul
adb shell rm /data/system/locksettings.db 2>nul
adb shell rm /data/system/locksettings.db-wal 2>nul
adb shell rm /data/system/locksettings.db-shm 2>nul
adb shell rm /data/system/password.key 2>nul

rem Method 4: Use newer Android API for lock settings
echo Trying method 4: Using newer lock settings API...
adb shell cmd lock_settings clear --user 0

echo NOTE: Screen lock removal may require manual confirmation on the device.
echo If methods fail, please manually disable screen lock in Settings > Security.
echo.

rem === Disable additional security features ===
echo [3/4] Disabling additional security features...
adb shell settings put global verifier_verify_adb_installs 0 2>nul
adb shell settings put global package_verifier_enable 0 2>nul
adb shell settings put secure install_non_market_apps 1 2>nul
echo Security features adjusted for easier APK installation.
echo.

rem === Install APK files ===
echo [4/4] Installing APK files...
set apk_count=0
for %%f in (*.apk) do (
    set /a apk_count+=1
)

if %apk_count% equ 0 (
    echo No APK files found in the current directory.
    goto :end
)

echo Found %apk_count% APK file(s) to install.
echo.

set install_count=0
set success_count=0

for %%f in (*.apk) do (
    set /a install_count+=1
    echo [!install_count!/%apk_count%] Installing "%%f"...
    
    rem Try installing with different flags for better compatibility
    adb install -r -t -d "%%f"
    if !errorlevel! equ 0 (
        echo SUCCESS: "%%f" installed successfully
        set /a success_count+=1
    ) else (
        echo FAILED: "%%f" installation failed
        echo Trying alternative installation method...
        adb install -r -g "%%f"
        if !errorlevel! equ 0 (
            echo SUCCESS: "%%f" installed with alternative method
            set /a success_count+=1
        ) else (
            echo ERROR: "%%f" could not be installed
        )
    )
    echo.
)

echo ================================================
echo Installation Summary:
echo Total APKs found: %apk_count%
echo Successfully installed: %success_count%
echo Failed installations: %install_count% - %success_count%
echo ================================================
echo.

rem === Final recommendations ===
echo RECOMMENDATIONS:
echo 1. If screen lock wasn't removed, manually go to Settings ^> Security ^> Screen Lock ^> None
echo 2. Check Settings ^> Apps for installed applications
echo 3. Some apps may require additional permissions - grant them manually
echo 4. Reboot the device if apps don't appear or behave unexpectedly

:end

echo.
echo ================================================
echo Press 'R' to run the script again or any other key to exit...
echo ================================================
choice /c:RX /n /m "Your choice: "
if %errorlevel%==1 (
    cls
    goto :start
)
echo.
echo Goodbye!
endlocal
pause
