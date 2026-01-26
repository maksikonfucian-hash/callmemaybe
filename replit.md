# callmemaybe

Flutter MVP for 1-on-1 audio/video calls with WebRTC Mesh + LiveKit.

## Project Overview

This is a Flutter monorepo project using Melos for package management. It supports multiple platforms including web, mobile (iOS/Android), and desktop.

## Project Structure

```
├── apps/
│   └── mobile/          # Main Flutter application
│       └── lib/         # Application source code
│       └── web/         # Web-specific assets
│       └── build/web/   # Built web application
├── packages/
│   ├── core/            # Shared entities, repositories, usecases
│   ├── signaling/       # WebRTC signaling logic
│   ├── webrtc_engine/   # WebRTC integration with JS and LiveKit
│   └── features/
│       └── contacts/    # Contacts feature module
├── js/
│   └── webrtc/          # JavaScript WebRTC logic
└── melos.yaml           # Monorepo configuration
```

## Technology Stack

- **Framework**: Flutter 3.32.0 with Dart 3.8.0
- **State Management**: Provider
- **WebRTC**: flutter_webrtc + LiveKit client
- **Architecture**: MVVM pattern with clean architecture

## Running the Application

### Development (Web)
The application runs as a Flutter web app served on port 5000.

```bash
cd apps/mobile
flutter pub get
flutter build web --base-href "/"
cd build/web && python3 -m http.server 5000 --bind 0.0.0.0
```

### Build Commands

```bash
# Get dependencies
cd apps/mobile && flutter pub get

# Build web
flutter build web --base-href "/"

# Run analysis
flutter analyze

# Run tests
flutter test
```

## Dependencies

Key dependencies:
- `livekit_client`: WebRTC SFU integration
- `flutter_js`: JavaScript integration for WebRTC logic
- `provider`: State management
- `fpdart`: Functional programming for error handling
- `http`: HTTP client
- `shared_preferences`: Local storage

## Environment

- Dart SDK: ^3.8.0
- Flutter: 3.32.0
- Platform: Web (also supports iOS, Android, Linux, macOS, Windows)
