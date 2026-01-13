# DriverSense Flutter App

A production-ready Flutter mobile app for **DriverSense** - a driver safety and wellness prevention platform. The app targets professional drivers (chauffeurs) and enables them to complete safety checks, track GPS routes, report incidents, and communicate with managers.

## Features

- **Authentication**: Login with email/password, 2FA support, GDPR consent
- **Check System**: Start and end checks with vehicle selection, km reading, wellness questions, and mood tracking
- **GPS Tracking**: Background location tracking with privacy zones
- **Incident Reporting**: Voice recording, photo capture, urgency levels
- **Chat**: Real-time messaging with managers
- **Achievements**: Badges, streaks, and goals
- **Offline-First**: Full offline support with automatic sync

## Tech Stack

- **Framework**: Flutter 3.x (latest stable)
- **Language**: Dart 3.x
- **State Management**: flutter_bloc (Cubit pattern)
- **Local Database**: Drift (SQLite) for offline-first
- **API Client**: Dio with interceptors
- **GPS**: Geolocator + flutter_background_service
- **Maps**: mapbox_maps_flutter
- **DI**: get_it + injectable
- **Navigation**: go_router
- **Forms**: reactive_forms
- **Localization**: flutter_localizations + intl (NL, EN, FR)

## Architecture

The project follows **Clean Architecture** with a **Feature-First** structure:

```
lib/
├── core/           # Core utilities, config, DI, network, storage, theme, router
├── features/       # Feature modules (auth, check, tracking, incidents, chat, etc.)
├── shared/         # Shared widgets and services
└── l10n/           # Localization files
```

Each feature follows the clean architecture pattern:
- **Data Layer**: Models, data sources, repository implementations
- **Domain Layer**: Entities, repositories (abstract), use cases
- **Presentation Layer**: BLoC/Cubit, pages, widgets

## Setup Instructions

### Prerequisites

- Flutter SDK 3.x
- Dart SDK 3.x
- Android Studio / Xcode

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-org/driversense_app.git
cd driversense_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Drift database, injectable):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Generate localizations:
```bash
flutter gen-l10n
```

### Running the App

```bash
# Development
flutter run --flavor dev

# Staging
flutter run --flavor staging

# Production
flutter run --flavor prod
```

### Running Tests

```bash
# Unit tests
flutter test

# With coverage
flutter test --coverage

# Integration tests
flutter drive --target=test_driver/app.dart
```

### Building for Release

```bash
# Android APK
flutter build apk --release --flavor prod

# Android App Bundle
flutter build appbundle --release --flavor prod

# iOS
flutter build ios --release --flavor prod
```

## Environment Configuration

Environment-specific configuration is managed through `lib/core/config/env_config.dart`:

- **dev**: Local development with mock services
- **staging**: Staging server for testing
- **prod**: Production environment

## Localization

The app supports three languages:
- **Dutch (nl)** - Default
- **English (en)**
- **French (fr)**

ARB files are located in `lib/l10n/` and generated localizations in `lib/l10n/generated/`.

## Offline Support

The app is built with an offline-first approach:
- All data is stored locally in SQLite (Drift)
- Automatic sync when connectivity is restored
- Priority sync: Checks > Incidents > Track Points > Messages

## Privacy Features

- **Privacy Zones**: GPS points inside user-defined zones are excluded from tracking
- **Data Retention**: Track points are kept for max 7 days locally
- **GDPR Consent**: Required before using the app

## Key Screens

1. **Login**: Email/password authentication
2. **Home**: Dashboard with quick actions, streak, and recent activity
3. **Start/End Check**: Multi-step flow with vehicle, km, questions, mood
4. **Active Trip**: Live map with stats and panic button
5. **Incident Report**: Voice recording and photo capture
6. **Settings**: Privacy zones, notifications, language

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

## License

Proprietary - DriverSense B.V.
