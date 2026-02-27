# PocketRead App (Flutter)

This is the cross-platform client for PocketRead (iOS, Android, Web, Desktop).

## Setup Instructions

Since this directory is currently empty (except for this README), you need to initialize the Flutter project:

```bash
# Initialize Flutter project
flutter create . --org com.pocketread --platforms android,ios,web,macos,windows,linux

# Add dependencies (recommended based on plan)
flutter pub add flutter_bloc equatable dio go_router isar isar_flutter_libs path_provider
flutter pub add -d isar_generator build_runner
```

## Architecture Overview

- **State Management**: BLoC (Business Logic Component) or Riverpod.
- **Local Database**: Isar (High performance, NoSQL).
- **Navigation**: GoRouter.
- **Networking**: Dio (for communicating with Cloudflare Workers).

## Key Features to Implement

1. **Authentication**: Input API Key and Server URL.
2. **Bookshelf**: List books from local DB and sync with server.
3. **Reader**: Custom engine for EPUB/TXT rendering.
4. **Sync**: Background sync service.

## Running

```bash
flutter run
```
