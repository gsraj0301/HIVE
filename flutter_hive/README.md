# HIVE - Scam Detection & Call Trap System

A Flutter-based mobile and web application for detecting scams, analyzing suspicious calls/messages, and providing intelligence reports on fraud patterns.

## 🎯 Features

- **Call Analysis**: Analyze call transcripts for scam indicators
- **Pattern Detection**: Identify known scam patterns in conversations
- **Risk Scoring**: Calculate fraud risk levels from suspicious content
- **Intelligence Reports**: View analytics and threat distribution dashboards
- **Scammer Database**: Track and search known scammers
- **Call Simulation**: Practice responding to simulated scam calls (call trap)
- **Spam Analysis**: Analyze and classify suspicious messages
- **Alerts & Logs**: Monitor suspicious activity with detailed logging

## 🚀 Quick Start

### Prerequisites
- Flutter 3.10+ with Dart 3.10+
- For web: No additional setup needed
- For mobile: Android SDK / Xcode

### Build & Run Locally

**Web:**
```bash
flutter pub get
flutter run -d web
```

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d iphone
```

## 📱 Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # All UI screens
│   ├── dashboard_screen.dart
│   ├── alerts_screen.dart
│   ├── call_trap_screen.dart
│   ├── intelligence_report_screen.dart
│   └── ...
├── services/
│   └── api_service.dart      # Backend API calls
├── models/                   # Data models
├── widgets/                  # Reusable widgets
└── theme/                    # App theme configuration
```

## 🌐 Deployment

### Render (Static Site Frontend)
See [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md) for step-by-step instructions to deploy the Flutter web UI as a Static Site on Render.

Quick summary:
1. Create a new Static Site on Render
2. Point to your GitHub repo
3. Set Build Command: `flutter build web --release`
4. Set Publish Directory: `build/web`

### Backend API
Deploy the Flask backend separately (see parent repo for details).

## 🔧 Configuration

**API Base URL** (in [lib/services/api_service.dart](lib/services/api_service.dart)):
- Local development: `http://localhost:5000/api`
- Android emulator: `http://10.0.2.2:5000/api`
- Production: Update to your deployed backend URL

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Render Deployment Guides](https://render.com/docs)
- [Dart Language](https://dart.dev/)
