# Cliqs - Premium Flutter Todo App 🚀

Cliqs is a modern, high-performance task management application built with Flutter. It demonstrates professional architecture patterns and follows industry best practices for scalable mobile development.

## 🧠 Key Architecture Patterns

- **Feature-First Clean Architecture**: Organized by distinct features (Auth, Tasks) with clearly defined layers:
    - **Data**: Remote Data Sources, Models, and Repository Implementations.
    - **Domain**: Entities, Repositories (Interface), and Use Cases.
    - **Presentation**: BLoC State Management and Premium UI Pages.
- **Global Error Handling**: Centralized `Failure` system with `dartz` (`Either`) for predictable error management.
- **Dependency Injection**: Utilizes `GetIt` for seamless service location and modularity.
- **State Management**: Robust `BLoC` pattern for unidirectional data flow and highly testable logic.

## ✨ Premium Features

- ✅ **Firebase Authentication**: Secure login, signup, and password recovery.
- ✅ **Realtime Sync**: Powered by Firebase Realtime Database for instant task updates.
- ✅ **Visual Excellence**: Modern UI with glassmorphism effects, custom gradients, and smooth animations.
- ✅ **Shimmer Loading**: Professional skeleton screens for improved UX during data fetching.
- ✅ **Animated Transitions**: Smooth list animations and hero effects for a premium feel.
- ✅ **Task Progress**: Dynamic progress tracking with curated visual feedback.
- ✅ **Swipe to Delete**: Intuitive gestures for efficient task management.

## 🛠 Tech Stack

- **UI Framework**: Flutter
- **State Management**: `flutter_bloc`
- **Navigation**: `go_router`
- **Animations**: `flutter_animate`
- **Database**: Firebase Realtime Database
- **Networking**: `http`
- **Local Utilities**: `connectivity_plus`, `equatable`, `dartz`, `get_it`, `shimmer`

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/ansar7787/cliqs-flutter-app.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

---
*Created with ❤️ by Ansar*
