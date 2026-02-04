# HIVE - Complete Setup & Run Instructions

## 📋 System Requirements

### For Flutter Frontend
- Flutter SDK 3.10.8 or higher
- Dart SDK (included with Flutter)
- Android SDK & Android Emulator (or physical Android device)
- 4GB RAM minimum

### For Python Backend
- Python 3.8 or higher
- pip (Python package manager)
- 2GB RAM minimum

### Operating System
- Windows, macOS, or Linux
- Tested on: Windows 10/11, macOS 12+, Ubuntu 20.04+

---

## 🔧 Installation Steps

### Step 1: Clone/Download Project

```bash
# Navigate to your workspace
cd ~/Documents  # or your preferred location

# The project should already be at:
# c:\Users\danse\OneDrive\ドキュメント\HIVE-PROJECT\
```

### Step 2: Set Up Python Backend

#### Windows Command Prompt/PowerShell:
```bash
# Navigate to backend folder
cd hive_backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Verify installation
pip list
```

#### macOS/Linux Terminal:
```bash
cd hive_backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip list
```

### Step 3: Set Up Flutter Frontend

#### Windows Command Prompt/PowerShell:
```bash
# Navigate to Flutter project
cd flutter_hive

# Get Flutter dependencies
flutter pub get

# Check Flutter setup
flutter doctor
```

#### macOS/Linux Terminal:
```bash
cd flutter_hive
flutter pub get
flutter doctor
```

**Expected `flutter doctor` output:**
```
✓ Flutter (version X.X.X)
✓ Android toolchain
✓ Android Studio
✓ Connected device (or emulator)
```

---

## 🚀 Running the Application

### Option A: Sequential Start (Recommended)

#### Terminal 1: Start Backend

```bash
# Windows
cd hive_backend
venv\Scripts\activate
python main.py

# macOS/Linux
cd hive_backend
source venv/bin/activate
python main.py
```

**Expected output:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete
```

✅ Backend is running at: `http://localhost:8000`

#### Terminal 2: Start Flutter App

```bash
# Windows & macOS/Linux
cd flutter_hive
flutter run
```

**Expected output:**
```
Launching lib/main.dart on...
Built a debug APK in...
Installing...
Starting app...
```

✅ App will launch on your emulator/device

---

### Option B: Run in Background (Advanced)

#### Windows - Start Backend in Background:
```bash
cd hive_backend
start cmd /k "venv\Scripts\activate && python main.py"
```

#### macOS/Linux - Start Backend in Background:
```bash
cd hive_backend
source venv/bin/activate
python main.py &
```

Then in a new terminal:
```bash
cd flutter_hive
flutter run
```

---

## 📱 Running on Different Devices

### Android Emulator
```bash
# Ensure emulator is running
flutter emulator --launch Pixel_4_API_30

# Then run:
flutter run
```

**Backend URL for emulator**: `http://10.0.2.2:8000`

### Physical Android Device
```bash
# Enable USB debugging on phone
# Connect phone to PC via USB
# Check if visible:
flutter devices

# Run:
flutter run

# Or build APK for installation:
flutter build apk
# APK location: flutter_hive/build/app/outputs/flutter-app.apk
```

**Backend URL for physical device**: `http://YOUR_PC_IP:8000`

Find your PC IP:
```bash
# Windows PowerShell
ipconfig

# macOS/Linux Terminal
ifconfig

# Look for IPv4 Address (e.g., 192.168.1.100)
```

---

## ✅ Verify Everything Works

### Test 1: Backend Health Check

```bash
# In a new terminal/browser
curl http://localhost:8000/health

# Expected response:
# {"status":"healthy","timestamp":"2024-02-04T..."}
```

### Test 2: Backend API Docs

Open browser and visit: `http://localhost:8000/docs`

You should see interactive Swagger UI with all endpoints.

### Test 3: App Launch

```bash
flutter run
```

You should see:
1. Splash screen (3 seconds)
2. Auto-navigate to Dashboard
3. Dashboard displays with mock data

### Test 4: Navigate Screens

In the running app, tap bottom navigation:
- Dashboard ✅
- Logs ✅
- Calls ✅
- Scammers ✅
- Alerts ✅
- Settings ✅

All screens should load with mock data.

---

## 🌐 API Testing

### Using Swagger UI (Recommended)

1. Go to: `http://localhost:8000/docs`
2. Click on any endpoint
3. Click "Try it out"
4. Modify parameters if needed
5. Click "Execute"
6. See response

### Using cURL Commands

```bash
# Get dashboard stats
curl http://localhost:8000/dashboard/stats

# Get attack logs
curl http://localhost:8000/logs?limit=5

# Get alerts
curl http://localhost:8000/alerts

# Get scammers
curl http://localhost:8000/scammers

# Analyze a call
curl -X POST http://localhost:8000/analyze-call \
  -H "Content-Type: application/json" \
  -d '{
    "phone_number": "+91-98765-43210",
    "transcript": "Hello sir, I am from ICICI Bank. Your account is compromised. Verify your UPI ID r.kumar@icici",
    "duration": 240,
    "keywords": []
  }'

# Start honeypot
curl -X POST http://localhost:8000/start-honeypot \
  -H "Content-Type: application/json" \
  -d '{
    "scammer_id": "scammer_01",
    "phone_number": "+91-98765-43210",
    "conversation_starter": "How can I help you?"
  }'
```

### Using Postman/Insomnia

1. Create new request
2. Set method: GET/POST
3. Set URL: `http://localhost:8000/endpoint-name`
4. Add headers: `Content-Type: application/json`
5. Add body for POST requests (as shown above)
6. Send and view response

---

## 🔧 Common Issues & Solutions

### Issue: Python not found
```bash
# Solution: Use python3 instead of python
python3 main.py

# Or add Python to PATH
# Windows: Search "Edit environment variables"
# macOS/Linux: export PATH="/usr/local/bin/python3:$PATH"
```

### Issue: Port 8000 already in use
```bash
# Solution: Use different port
uvicorn main:app --host 0.0.0.0 --port 8080

# Then update Flutter to use: http://localhost:8080
```

### Issue: Virtual environment won't activate
```bash
# Windows - Try:
venv\Scripts\activate.bat

# If that fails - Reinstall:
python -m venv venv --clear
venv\Scripts\activate
pip install -r requirements.txt
```

### Issue: Flutter won't find device
```bash
# Check devices
flutter devices

# If emulator not listed, start it:
flutter emulator --launch <emulator_name>

# List available emulators:
flutter emulators
```

### Issue: App crashes on startup
```bash
# Clean build
flutter clean

# Get dependencies again
flutter pub get

# Run
flutter run

# Check for errors
flutter analyze
```

### Issue: Backend gives CORS error
```
# Backend already has CORS enabled
# If still failing, check:
# 1. Backend is running at http://localhost:8000
# 2. Android emulator uses: http://10.0.2.2:8000
# 3. Physical device uses your PC IP
```

---

## 📊 Demo Flow

### Recommended Demo Sequence (5 minutes)

1. **Start Backend** (10 seconds)
   ```bash
   python main.py
   ```
   Show: "Uvicorn running on http://0.0.0.0:8000"

2. **Launch App** (20 seconds)
   ```bash
   flutter run
   ```
   Show: Splash screen → Dashboard

3. **Show Dashboard** (30 seconds)
   - Point out attack chart
   - Show total attacks counter
   - Highlight attack type chips

4. **Navigate Logs** (30 seconds)
   - Show log filtering
   - Click a log to see details
   - Highlight extracted keywords

5. **Demo Call Simulation** (60 seconds)
   - Go to "Calls" tab
   - Tap a spam call
   - Show conversation transcript
   - Highlight extracted keywords
   - Show AI honeypot responses

6. **Show Scammers** (20 seconds)
   - View scammer list
   - Show risk levels
   - Tap one for details

7. **Show Alerts** (20 seconds)
   - View critical alerts
   - Show severity filtering
   - Highlight suggested actions

8. **Show Settings** (10 seconds)
   - Toggle switches
   - Show app info
   - Privacy policy

9. **Test API** (30 seconds)
   - Open `http://localhost:8000/docs`
   - Try `/analyze-call` endpoint
   - Show risk scoring results

**Total Demo Time**: ~5 minutes

---

## 📈 Performance Checklist

Before demo, verify:
- ✅ Backend responds in <100ms
- ✅ App screens load smoothly
- ✅ Navigation is responsive
- ✅ No lag when scrolling lists
- ✅ Animations are smooth
- ✅ Tap response is immediate
- ✅ API responses are <500ms

---

## 🧹 Cleanup & Shutdown

### Stop Backend
```bash
# Press Ctrl+C in the terminal running backend
# Or if in background, find and kill process:

# Windows PowerShell:
Get-Process python | Stop-Process

# macOS/Linux:
pkill -f "python main.py"
```

### Stop Flutter App
```bash
# Press Ctrl+C in the terminal running flutter
# Or use Flutter UI
```

### Deactivate Virtual Environment
```bash
# Windows, macOS, Linux:
deactivate
```

---

## 📦 Package Structure

### Flask Project Files
```
hive_backend/
├── main.py           # 400+ lines of FastAPI code
├── requirements.txt  # 4 packages
└── __pycache__/      # Auto-generated
```

### Flutter Project Files
```
flutter_hive/
├── lib/              # 2500+ lines of Dart code
│   ├── main.dart
│   ├── screens/      # 7 files
│   ├── widgets/      # 5 files
│   ├── models/       # 4 files
│   ├── mock_data/    # 4 files
│   └── theme/        # 1 file
├── pubspec.yaml      # 12 dependencies
└── build/            # Auto-generated
```

---

## 🎯 Next Steps After Demo

1. **Take Feedback** - What judges liked/didn't like
2. **Plan Improvements**:
   - Real database integration
   - Actual call interception
   - Machine learning models
   - More realistic AI responses
3. **Add Features**:
   - User authentication
   - Real-time push notifications
   - Call recording and playback
   - Integration with law enforcement
4. **Deploy**:
   - Cloud backend (AWS/GCP/Azure)
   - App Store release
   - Production database

---

## 📞 Quick Reference

| Task | Command |
|------|---------|
| Start Backend | `cd hive_backend && python main.py` |
| Start App | `cd flutter_hive && flutter run` |
| API Docs | `http://localhost:8000/docs` |
| Health Check | `curl http://localhost:8000/health` |
| Clean Flutter | `flutter clean` |
| Check Emulators | `flutter emulators` |
| Device List | `flutter devices` |
| Deactivate Env | `deactivate` |

---

## ✨ You're Ready!

Everything is configured and ready to:
- ✅ Run locally on your machine
- ✅ Demo at hackathon
- ✅ Test all features
- ✅ Extend with real data

**Start with**: `python main.py` then `flutter run`

**Happy coding!** 🚀

---

**Last Updated**: February 4, 2026  
**Status**: Production-Ready for Demo
