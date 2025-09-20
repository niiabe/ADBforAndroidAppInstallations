# Android ADB Installer & Device Configurator

This repository contains a Windows batch script (`install.bat`) designed to automate the configuration of a connected Android device and the installation of APK files using the Android Debug Bridge (ADB).

## Prerequisites

Before using this script, you must have the following:

1.  **Windows Operating System**: The script is a `.bat` file and is intended for Windows.
2.  **Android Debug Bridge (ADB)**:
    *   ADB must be installed on your computer. You can get it with the [Android SDK Platform Tools](https://developer.android.com/studio/releases/platform-tools).
    *   The `adb.exe` executable must be in your system's `PATH`. The script will not work if it cannot find `adb`.
3.  **Android Device**:
    *   An Android device connected to your computer via USB.
    *   **Developer Options** must be enabled on the device.
    *   **USB Debugging** must be enabled within Developer Options.
    *   You may need to authorize the USB debugging connection on your device when you first connect it to your PC.

## How to Use

1.  **Place APK Files**: Put all the `.apk` files you want to install into the same directory as the `install.bat` script.
2.  **Connect Your Device**: Connect your Android device to your computer and ensure it is recognized by ADB. You can check this by opening a command prompt and running `adb devices`. Your device should be listed.
3.  **Run the Script**: Double-click `install.bat` to run it. The script will guide you through the process.
4.  **Follow On-Screen Instructions**: The script will show its progress and any errors that occur. It may ask for your input, for example, to run the script again.

## What This Script Does

The script performs the following actions in order:

1.  **Checks for ADB and Devices**:
    *   Verifies that `adb` is installed and accessible.
    *   Checks if an Android device is connected.

2.  **Sets Display Timeout**:
    *   Changes the device's screen timeout to **30 minutes** to prevent it from sleeping during the process.

3.  **Removes Screen Lock**:
    *   Attempts to remove the screen lock (PIN, pattern, password) using several different methods, including clearing lock settings and attempting to set a blank password/PIN to force the lock to 'None'.
    *   **Note**: This may not work on all devices or Android versions due to varying security restrictions. If it fails, you may need to disable the screen lock manually in `Settings > Security`.

4.  **Disables Security Features**:
    *   Adjusts device settings to allow the installation of apps from unknown sources and disables app verification over ADB. This is necessary for installing APKs that are not from the Google Play Store.

5.  **Installs APKs and Grants Permissions**:
    *   Scans the current directory for any files with the `.apk` extension.
    *   Installs each APK and attempts to grant all runtime permissions (like file access) automatically by using the `-g` flag with `adb install`.
    *   If the installation with permissions fails, it attempts a standard installation without granting permissions. In this case, you may need to grant permissions manually.

6.  **Provides a Summary**:
    *   At the end, it shows a summary of how many APKs were found and how many were installed successfully.

7.  **Gives Recommendations**:
    *   Suggests manual steps to take if any part of the automated process failed.

## Troubleshooting

*   **"Error: ADB is not found"**: This means `adb.exe` is not in your system's `PATH`. You need to add the folder containing `adb.exe` to your system's environment variables.
*   **"Error: No ADB devices found"**:
    *   Make sure your device is properly connected.
    *   Check that USB Debugging is enabled.
    *   Ensure you have authorized the connection on your device.
    *   You may need to install the appropriate USB drivers for your device.
*   **APK Installation Fails**:
    *   The APK might be corrupt or incompatible with your device's Android version or architecture.
    *   You might not have enough storage space on your device.
*   **Screen Lock is Not Removed**:
    *   Modern Android versions have increased security, and removing the lock screen via ADB is often restricted. If the script fails to do so, you must remove it manually through the device's settings.

## Disclaimer

This script modifies system settings on your Android device. Use it at your own risk. The author is not responsible for any damage or data loss that may occur. It is recommended for use in testing and development environments.
