# Professional Todo App - Flutter & Firebase

A production-level Todo List application built with **Flutter**, **Firebase**, and **Clean Architecture**. This project demonstrates best practices in state management, networking, and UI/UX design.

## 🚀 Features

- **Authentication**: Secure Email/Password login and signup using Firebase Auth.
- **Task Management**: Full CRUD operations (Create, Read, Update, Delete) for tasks.
- **REST API Integration**: Communicates with Firebase Realtime Database via standard HTTP REST calls.
- **State Management**: Implemented using **BLoC** for a predictable and testable state flow.
- **Clean Architecture**: Strictly separated into **Presentation**, **Domain**, and **Data** layers.
- **Functional Error Handling**: Uses the **Dartz** library (`Either`) for robust error management.
- **Modern UI/UX**:
  - **Shimmer Effects** for smooth loading states.
  - **Micro-animations** using `flutter_animate`.
  - **Swipe-to-Delete** functionality.
  - **Progress Tracking** for daily tasks.
  - **Responsive Design** for different screen sizes.
  - **Dark & Light Mode** support.

## 🛠 Tech Stack

- **Flutter SDK**
- **Firebase Auth & Realtime Database**
- **BLoC** (State Management)
- **GetIt** (Dependency Injection)
- **Dartz** (Functional Programming)
- **http** (REST API)
- **ScreenUtil** (Responsiveness)
- **Shimmer** (Skeleton Loading)
- **Animate** (UI Effects)

## 📂 Architecture Overview

The app follows a 3-layer Clean Architecture:
1. **Presentation**: UI Widgets and BLoCs.
2. **Domain**: Pure business logic (Entities, Repositories Interfaces, UseCases).
3. **Data**: Specific implementations (Models, DataSources, Repository Impl).

## 📥 How to Run

1. Clone the repository.
2. Run `flutter pub get`.
3. Ensure Firebase is configured (run `flutterfire configure`).
4. Run the app: `flutter run`.

## 📦 Build APK
To generate the production APK:
```bash
flutter build apk --release
```
The APK will be located in `build/app/outputs/flutter-apk/app-release.apk`.
