Visit Tracker App
A Flutter application for tracking sales visits and managing client interactions with real-time location verification.
Overview
Visit Tracker helps sales reps manage their daily client visits, track locations, and maintain visit records. Built with Flutter and GetX for efficient state management and navigation.
Features

Visit Management: Schedule and track client visits
Location Tracking: GPS verification for visit authenticity
Client Database: Manage client information and visit history
Offline Support: Works without internet, syncs when connected
Visit Reports: Add notes, photos, and visit outcomes
Analytics Dashboard: View visit statistics and performance metrics

Architecture
Built using GetX Architecture pattern for clean, reactive development:
Why GetX?

State Management: Reactive programming with minimal boilerplate
Route Management: Simple navigation without context
Dependency Injection: Easy service management and testing
Performance: Lightweight with excellent memory management

Project Structure
lib/
├── app/
│   ├── data/           # Models, providers, repositories
│   ├── modules/        # Feature modules (controllers, views, bindings)
│   ├── routes/         # App routes and pages
│   └── services/       # Global services (API, storage, etc.)
├── core/               # Constants, themes, utilities
└── main.dart
Setup Instructions
Requirements

Flutter SDK 3.0+
Dart 2.17+
Android Studio or VS Code

Installation

Clone the repo
git clone <repository-url>
cd sales_force_

Install dependencies
flutter pub get

Run the app
flutter run


get: State management, routing, dependency injection
get_storage: Lightweight local storage
connectivity_plus: Network status monitoring

Building
Debug APK:
flutter build apk --debug
Release APK:
flutter build apk --release
iOS:
bashflutter build ios --release

GetX Benefits Used
Reactive Variables: .obs variables for automatic UI updates
GetConnect: Built-in HTTP client for API calls
GetStorage: Simple key-value storage
Get.find(): Easy dependency injection
Get.to(): Context-free navigation
GetX Widgets: Efficient rebuilding with GetX and Obx

Performance Features
Lazy Loading: Controllers created only when needed
Memory Management: Automatic disposal with GetX lifecycle
Efficient Rebuilds: Only affected widgets rebuild
