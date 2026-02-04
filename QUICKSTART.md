# HIVE - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Start the Backend (Python)

```bash
cd hive_backend
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Mac/Linux

pip install -r requirements.txt
python main.py
```

✅ Backend running at: `http://localhost:8000`
✅ API Docs at: `http://localhost:8000/docs`

### Step 2: Launch the Flutter App

In a new terminal:

```bash
cd flutter_hive
flutter pub get
flutter run
```

✅ App opens on Android emulator/device
✅ Splash screen → Dashboard

---

## 🎯 Demo Flow

1. **Splash Screen** (3 seconds) → Auto-navigates to Dashboard
2. **Dashboard** - View attack statistics and charts
3. **Logs Tab** - Browse attack logs with filters
4. **Calls Tab** - Simulate spam calls and honeypot responses
5. **Scammers Tab** - See tracked scammer profiles
6. **Alerts Tab** - Review critical security alerts
7. **Settings Tab** - Toggle security features

---

## 📱 Bottom Navigation Bar

```
[Dashboard] [Logs] [Calls] [Scammers] [Alerts] [Settings]
```

---

## 🔌 Connecting Frontend to Backend

**Android Emulator** (default):
- Backend URL: `http://10.0.2.2:8000`

**Physical Device**:
- Find your PC IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
- Update URL to: `http://YOUR_IP:8000`

---

## 🧪 Test Backend with cURL

```bash
# Get dashboard stats
curl http://localhost:8000/dashboard/stats

# Get attack logs
curl http://localhost:8000/logs

# Analyze a call
curl -X POST http://localhost:8000/analyze-call \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+91-98765-43210","transcript":"Hello sir, I am from ICICI Bank. Verify your UPI ID r.kumar@icici","duration":240,"keywords":[]}'

# Interactive API testing: http://localhost:8000/docs
```

---

## 📦 What's Included

### Frontend (Flutter)
- ✅ 6 complete screens
- ✅ 6 reusable widgets
- ✅ 4 data models
- ✅ 4 mock data generators
- ✅ Dark purple/blue theme
- ✅ Bottom navigation with smooth transitions
- ✅ Keyword highlighting in calls

### Backend (FastAPI)
- ✅ 13 RESTful endpoints
- ✅ Call analysis & risk scoring
- ✅ AI honeypot engagement
- ✅ Keyword extraction (UPI, banks, URLs)
- ✅ Mock data generators
- ✅ CORS enabled
- ✅ Interactive Swagger UI

---

## 🎨 Color Scheme

| Element | Color | Hex |
|---------|-------|-----|
| Primary | Deep Purple | #1A0033 |
| Secondary | Vibrant Purple | #6B2FB5 |
| Accent | Cyber Blue | #0099FF |
| Bright | Cyan | #00FFFF |
| Critical | Red | #FF3366 |
| Success | Green | #00DD99 |

---

## 📋 Mock Data Overview

### Attack Logs
- 8 realistic attack scenarios
- Types: Phishing, DDoS, Malware, SMS Spoofing, etc.
- Extracted keywords from each attack
- Severity: Critical, High, Medium, Low

### Alerts
- 5 real-world scam scenarios
- Suggested actions for users
- Severity-based highlighting

### Scammers
- 7 known scammer profiles
- Call counts and regions
- Honeypot engagement status

### Spam Calls
- 3 detailed call transcripts
- Message-by-message AI responses
- Real-time keyword extraction

---

## ⚙️ Project Files

```
HIVE-PROJECT/
├── flutter_hive/
│   ├── lib/
│   │   ├── main.dart                 # App entry + navigation
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── logs_screen.dart
│   │   │   ├── call_simulation_screen.dart
│   │   │   ├── scammers_screen.dart
│   │   │   ├── alerts_screen.dart
│   │   │   └── settings_screen.dart
│   │   ├── widgets/
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── total_attacks_card.dart
│   │   │   ├── attack_type_chip.dart
│   │   │   ├── severity_badge.dart
│   │   │   └── keyword_highlight.dart
│   │   ├── models/
│   │   │   ├── attack_log.dart
│   │   │   ├── scammer.dart
│   │   │   ├── alert.dart
│   │   │   └── call.dart
│   │   ├── mock_data/
│   │   │   ├── mock_calls.dart
│   │   │   ├── mock_alerts.dart
│   │   │   ├── mock_logs.dart
│   │   │   └── mock_scammers.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   ├── pubspec.yaml
│   └── README.md
│
├── hive_backend/
│   ├── main.py          # FastAPI server + 13 endpoints
│   ├── requirements.txt  # Python dependencies
│   └── README.md
│
└── README.md            # Full documentation
```

---

## 🐛 Troubleshooting

### Flutter app won't connect to backend
```
→ Ensure backend is running: python main.py
→ Check URL: http://10.0.2.2:8000 (Android emulator)
→ For physical device, use your machine IP
```

### Backend won't start
```
→ Check Python version: python --version (must be 3.8+)
→ Install dependencies: pip install -r requirements.txt
→ Try different port: uvicorn main:app --host 0.0.0.0 --port 8080
```

### App crashes on launch
```
→ Clean build: flutter clean
→ Get dependencies: flutter pub get
→ Check for Dart errors: flutter analyze
```

---

## 🎓 Key Features to Demo

1. **Dashboard Analytics**
   - Real-time attack chart
   - Total attacks counter with trend

2. **Call Simulation**
   - Realistic spam call transcripts
   - AI honeypot responses
   - Live keyword extraction

3. **Intelligence Database**
   - Known scammer profiles
   - Risk level indicators
   - Honeypot engagement status

4. **Smart Detection**
   - Automatic keyword extraction
   - Risk scoring algorithm
   - Severity classification

5. **Professional UI**
   - Cybersecurity dark theme
   - Glassmorphism effects
   - Smooth animations & transitions

---

## 📊 API Endpoints Quick Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API info |
| GET | `/health` | Health check |
| GET | `/dashboard/stats` | Dashboard metrics |
| GET | `/logs` | Attack logs (paginated) |
| GET | `/alerts` | Security alerts |
| GET | `/scammers` | Scammer database |
| POST | `/analyze-call` | **Analyze call for risk** |
| POST | `/start-honeypot` | **Start AI engagement** |
| POST | `/honeypot/respond` | **Get AI response** |
| POST | `/alert` | Create alert |

---

## 💡 Tips

- Use `/docs` endpoint for interactive API testing
- Mock data refreshes on each request (no database)
- All data is generated server-side (frontend uses mock)
- Theme colors defined in `AppTheme` class
- Models support `.fromJson()` and `.toJson()` for API integration

---

## 🏁 You're Ready!

The entire HIVE system is ready for:
- ✅ Hackathon demo
- ✅ API testing
- ✅ UI showcase
- ✅ Feature walkthrough
- ✅ Integration with real backend

**Good luck! 🚀**
