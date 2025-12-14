# Uber Clone Flutter Apps

This directory contains the refactored Flutter applications for the Uber Clone, separated by role.

## App Structure

### Rider App
A dedicated Flutter application for riders with features:
- Ride request interface
- Map view for pickup and destination
- Fare estimation
- Ride history
- Profile management

### Driver App
A dedicated Flutter application for drivers with features:
- Availability toggle (online/offline)
- Ride request notifications
- Navigation to pickup location
- Earnings dashboard
- Ride history

### Admin App
A dedicated Flutter application for administrators with features:
- User management dashboard
- Analytics and reporting
- System configuration
- Support ticket management

## Shared Package

The `uber_shared` package contains common components, models, and utilities used across all three applications to ensure consistency and reduce code duplication.

## Getting Started

### Prerequisites
- Flutter SDK (3.10.4+ recommended)
- Dart SDK (3.0.0+ recommended)
- Android Studio / Xcode for emulators

### Installation
Navigate to each app directory and get dependencies:

```bash
# Rider App
cd rider_app
flutter pub get

# Driver App
cd driver_app
flutter pub get

# Admin App
cd admin_app
flutter pub get
```

### Running Apps
```bash
# Rider App
cd rider_app
flutter run

# Driver App
cd driver_app
flutter run

# Admin App
cd admin_app
flutter run
```

## Adding the Shared Package

To use the shared package in each app, add it as a dependency in each app's `pubspec.yaml`:

```yaml
dependencies:
  uber_shared:
    path: ../flutter-packages/uber_shared
```