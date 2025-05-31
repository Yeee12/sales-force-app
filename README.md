# Visit Tracker App

A Flutter application for tracking sales visits and managing client interactions with real-time location verification.

## Overview

Visit Tracker helps sales reps manage their daily client visits, track locations, and maintain visit records. Built with Flutter and GetX for efficient state management and navigation.

### 📸 Screenshots

![Screenshot 1](https://github.com/user-attachments/assets/d194eb97-164d-4298-bbb0-0bd9a967769a)
![Screenshot 2](https://github.com/user-attachments/assets/86767801-073f-4935-aa4e-b3e870f30bf9)
![Screenshot 3](https://github.com/user-attachments/assets/57b45dff-9885-4be0-a351-608aaf27d9bc)
![Screenshot 4](https://github.com/user-attachments/assets/eb581e34-d255-4f2c-bab6-83dadba0d1f3)

---

## 🚀 Features

- **Visit Management**: Schedule and track client visits  
- **Location Tracking**: GPS verification for visit authenticity  
- **Client Database**: Manage client information and visit history  
- **Offline Support**: Works without internet, syncs when connected  
- **Visit Reports**: Add notes, photos, and visit outcomes  
- **Analytics Dashboard**: View visit statistics and performance metrics  

---

## 🏗 Architecture

Built using GetX Architecture pattern for clean, reactive development:

### Why GetX?

- **State Management**: Reactive programming with minimal boilerplate  
- **Route Management**: Simple navigation without context  
- **Dependency Injection**: Easy service management and testing  
- **Performance**: Lightweight with excellent memory management  

---

## 📁 Project Structure
lib/
├── app/
│ ├── data/ # Models, providers, repositories
│ ├── modules/ # Feature modules (controllers, views, bindings)
│ ├── routes/ # App routes and pages
│ └── services/ # Global services (API, storage, etc.)
├── core/ # Constants, themes, utilities
└── main.dart


---

## ⚙️ Setup Instructions

### Requirements

- Flutter SDK 3.0+  
- Dart 2.17+  
- Android Studio or VS Code  

### Installation

```bash
git clone <repository-url>
cd sales_force_
flutter pub get
flutter run
get: State management, routing, dependency injection

get_storage: Lightweight local storage

connectivity_plus: Network status monitoring

### Build
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# iOS (macOS only)
flutter build ios --release

