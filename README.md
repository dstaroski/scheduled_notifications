# Scheduled Notifications

A Flutter project for scheduling notifications for Android. Using SQLite database technology, 
it is possible to store, edit, and delete notification times, 
as well as schedule multiple times.

## ✨ Features

* Multiple schedules for notification
* Use SQLite database for data persistence
* Works post reboot device
* Daily notifications
* Offline notifications, works without internet
* Works in older Android and newest
* Simple and modern layout with drawer menu

## 🛠️ Packages and Technologies

* Flutter and Dart
* sqflite
* path
* flutter_local_notifications
* flutter_timezone
* timezone

Their respective versions are in the pubspec.yaml file.

## 🚀 How execute the project

### Prerequisites

* Flutter SDK
* Android device or emulator with an hour in a 24 format
* JDK 17
* IDE (Android Studio or VS Code)

### Step by step

1. Clone repository
    ```bash
    git clone [https://github.com/dstaroski/scheduled_notifications.git](https://github.com/dstaroski/scheduled_notifications.git)
   
2. Open project in IDE

3. Run on terminal
    ```bash
    flutter pub get
   
4. Choose a device for run on IDE

5. Execute
    ```bash
    flutter run
   
6. Or compile an Apk and install
    ```bash
    flutter build apk

In this case, the APK file will be located in the folder: ..\scheduled_notifications\build\app\outputs\flutter-apk\app-release.apk.

## Conclusion and Observations

In the `build.gradle.kts` file (`../android/app/build.gradle.kts`), 
two lines have been added to enable compatibility between the `flutter_local_notifications` 
package and desugaring — which is required for the project to compile. These lines are:
`isCoreLibraryDesugaringEnabled = true` and `add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:2.1.4")`.

In the Android manifest file (`../android/app/src/main/AndroidManifest.xml`),
certain permissions have been added to ensure notifications
work on both older and newer versions of Android, as well as to
allow notifications to continue running after the device restarts.

Finally, I am a beginner Flutter developer, so you might encounter potential 
logic errors or a lack of best practices in my code, 
even though I tried to write it following standard conventions as 
much as possible. Feel free to use and modify it for your own projects. 
I hope it proves useful to you. Thank you!