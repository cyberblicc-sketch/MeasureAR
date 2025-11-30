# SensorToolkitAR: Cross-Platform AR Tape Measure and Sensor Toolkit

## Project Overview

This project is a cross-platform mobile application developed using **React Native** that combines the concept of the "iOS Sensor Toolkit" web application with a primary feature: an **Augmented Reality (AR) Tape Measure/Ruler**.

The AR Tape Measure functionality is implemented using **custom native modules** to ensure the best performance and direct access to the device's AR capabilities:
*   **iOS**: Uses Swift and **ARKit** for precise distance measurement.
*   **Android**: Uses Java and **ARCore** (simulated structure in the sandbox) for distance measurement.

The original sensor toolkit features (NFC Reader, Bluetooth Scanner, etc.) are currently represented by a placeholder UI, which serves as a foundation for future native module integration.

## Prerequisites

To build and run this application, you will need:

1.  **Node.js** (LTS version, e.g., 18.x or 20.x)
2.  **pnpm** (or npm/yarn, but `pnpm` is used in the project)
3.  **React Native CLI** (`npx react-native`)
4.  **Android Studio** with Android SDK and a compatible ARCore-enabled emulator or physical device.
5.  **Xcode** with Command Line Tools and a compatible ARKit-enabled physical device (iPhone 8 or later).

## Setup Instructions

1.  **Navigate to the project directory:**
    ```bash
    cd SensorToolkitAR
    ```

2.  **Install JavaScript dependencies:**
    ```bash
    pnpm install
    ```

3.  **Native Module Configuration (Crucial for AR Feature)**

    ### iOS (ARKit)
    The custom AR module is implemented in Swift. You must open the project in Xcode to ensure the native code is correctly compiled and linked.

    *   Navigate to the `ios` directory and install CocoaPods:
        ```bash
        cd ios
        pod install
        cd ..
        ```
    *   The custom files are located in `ios/ARModule/`. You may need to manually add the `ARViewManager.swift` and `ARView.swift` files to your Xcode project's main target if they are not automatically detected.

    ### Android (ARCore)
    The custom AR module is implemented in Java. The necessary files are in `android/app/src/main/java/com/sensortoolkitar/ar/`.

    *   The `ARPackage.java` is already registered in `MainApplication.kt`.
    *   **Note**: For a real ARCore application, you would need to add the ARCore dependency to `android/app/build.gradle` and ensure the device supports ARCore. The current implementation uses a simulated touch-based distance calculation for structural completeness.

## Build and Run

### Android

1.  Start an ARCore-compatible Android emulator or connect a physical device.
2.  Run the application:
    ```bash
    npx react-native run-android
    ```

### iOS

1.  Navigate to the `ios` directory and open the workspace file:
    ```bash
    open ios/SensorToolkitAR.xcworkspace
    ```
2.  Select a physical device (ARKit requires a real device).
3.  Build and run the application from Xcode. Alternatively, you can run from the command line:
    ```bash
    npx react-native run-ios --device "Your Device Name"
    ```

## AR Tape Measure Usage

1.  Select the **"AR Tape Measure"** tab.
2.  The camera view will open (if permissions are granted).
3.  **Tap** on a real-world surface to place the **start point**.
4.  **Tap** on a second point to place the **end point**.
5.  The distance between the two points will be calculated and displayed on the screen.
6.  Placing the second point will clear the measurement and prepare for a new one.

## Future Work

The **"Sensor Toolkit"** tab currently contains a placeholder. The next steps for a full implementation would involve:

1.  Creating native modules for each sensor feature (NFC, Bluetooth, Motion, etc.) for both iOS and Android.
2.  Developing the React Native JavaScript components to display the data from these native sensor modules.
3.  Integrating the `RandomScriptableAPI.js` logic (if desired) into a dedicated module for iOS Scriptable/Shortcuts integration.
