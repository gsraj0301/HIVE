# HIVE Quick Start - Final Steps to Hackathon Submission

## ⚡ 15-Minute Setup Guide

### Step 1: Start Backend (3 minutes)

```bash
# Navigate to backend directory
cd hive-backend

# Install dependencies (first time only)
npm install

# Start development server
npm run dev

# Expected output:
# ✅ MongoDB connected
# 🚀 HIVE Backend running on port 5000
# 📍 Environment: development
# 🔗 Health check: http://localhost:5000/api/health
```

**Verify**: Open browser → `http://localhost:5000/api/health`
Should see: `{"status": "HIVE Backend is running!", ...}`

### Step 2: Connect Flutter App (3 minutes)

```bash
# In a new terminal, navigate to Flutter app
cd flutter_hive

# Get dependencies
flutter pub get

# Run app (choose platform)
flutter run -d chrome      # Web browser
flutter run -d emulator    # Android emulator
flutter run -d device      # Physical device

# Expected: App opens with 9 navigation tabs
```

**Verify**: 
- All 9 tabs visible at bottom
- Can navigate between screens without crashing
- Dashboard shows mock data

### Step 3: Test API Integration (3 minutes)

**In Flutter App:**
1. Go to "Analyze" tab
2. Select "EMAIL" from dropdown
3. Paste test message:
   ```
   Congratulations! You won ₹50 lakhs! Click here to claim: https://lottery-claim.com
   ```
4. Click "Analyze Message"
5. Should see spam analysis results

**Expected Result:**
- Spam Score: 50-70
- Type: Lottery Scam
- Suggested reply displayed

### Step 4: Test with Postman (3 minutes)

**Option 1: Quick API Test**
```bash
# In terminal, test health endpoint
curl http://localhost:5000/api/health

# Expected: Status OK message
```

**Option 2: Use Postman Collection**
1. Open Postman
2. Import: `hive-backend/HIVE-API-Postman.json`
3. Set `base_url` = `http://localhost:5000`
4. Run "Analyze Spam Message - Lottery"
5. See API response with spam analysis

### Step 5: Build Release APK (5 minutes)

```bash
cd flutter_hive

# Build release APK (optimized, smaller size)
flutter build apk --release

# Output location:
# build/app/outputs/flutter-app-release.apk

# File size: ~50-70 MB

# For debugging:
flutter build apk --debug  # Larger, but easier to debug
```

**Verify APK:**
```bash
# Check file exists and size
ls -lh build/app/outputs/flutter-app-release.apk
```

### Step 6: Upload to Google Drive (2 minutes)

1. Go to Google Drive: https://drive.google.com
2. Create new folder: "HIVE_Hackathon"
3. Upload APK file from `build/app/outputs/`
4. Right-click APK → Get link
5. Change permissions to "Anyone with the link"
6. Copy shareable link

**Link format:**
```
https://drive.google.com/file/d/[FILE_ID]/view?usp=sharing
```

### Step 7: Update PowerPoint Presentation

Add to your hackathon submission:

```markdown
## Download & Test HIVE App

**APK Download**: [Paste Google Drive Link Here]

### Quick Start:
1. Download APK file
2. Install on Android device
3. Launch app
4. Go to "Analyze" tab to test spam detection
5. Go to "Call Trap" to see scam simulation
6. Go to "Intelligence" to view reports

### Features:
- Real-time spam detection
- Scammer call simulation
- Intelligence extraction
- Law enforcement reports
- Dark cybersecurity theme

### Tech Stack:
- Frontend: Flutter 3.10.8
- Backend: Node.js + Express
- Database: MongoDB
- APIs: 25+ endpoints
```

## 🧪 Testing Checklist Before Submission

### Backend
- [ ] Server starts without errors
- [ ] Health check endpoint works
- [ ] MongoDB connection successful
- [ ] No errors in console

### Frontend
- [ ] App launches without crashes
- [ ] All 9 screens navigable
- [ ] Mock data visible on dashboard
- [ ] Analyze screen connects to backend

### Integration
- [ ] Analyze screen gets real data from backend
- [ ] Results display correctly
- [ ] No connection errors

### APK
- [ ] File created successfully
- [ ] File size reasonable (< 100 MB)
- [ ] Installs on Android device
- [ ] Runs without crashes

### Submission
- [ ] Google Drive link works
- [ ] Anyone can download
- [ ] PowerPoint has download link
- [ ] README updated
- [ ] Code committed to GitHub

## 🚨 Troubleshooting

### Backend Won't Start
```bash
# Check if port 5000 in use
lsof -i :5000

# Kill existing process
kill -9 [PID]

# Try again
npm run dev
```

### MongoDB Connection Error
```bash
# Verify MongoDB URI in .env
# Should be: mongodb+srv://user:pass@cluster.mongodb.net/hive-db
# Or local: mongodb://localhost:27017/hive-db

# If local, start MongoDB:
mongod
```

### Flutter App Won't Connect to Backend
```bash
# 1. Check backend is running (port 5000)
# 2. For Android emulator, use: http://10.0.2.2:5000/api
# 3. For iOS simulator, use: http://localhost:5000/api
# 4. Edit in: lib/services/api_service.dart
```

### APK Build Fails
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Try again
flutter build apk --release

# If still fails, check:
# - Android SDK installed
# - Java version correct
# - Disk space available
```

## 📊 Demo Script (5-10 minutes)

**For Hackathon Judges:**

1. **Launch App** (30 seconds)
   - Show app launching
   - Navigate through all 9 tabs

2. **Spam Detection** (2 minutes)
   - Go to "Analyze" tab
   - Paste test message (phishing/lottery)
   - Show results: spam score, threat type, keywords
   - Show suggested auto-reply

3. **Call Simulation** (2 minutes)
   - Go to "Call Trap" tab
   - Generate banking call
   - Show conversation stages
   - Advance through 2-3 stages
   - Show manipulation techniques detected

4. **Intelligence Report** (2 minutes)
   - Go to "Intelligence" tab
   - Show threat distribution
   - Show top threats
   - Explain law enforcement use

5. **Dashboard** (1 minute)
   - Go back to "Home" tab
   - Show statistics
   - Explain analytics

6. **Tech Stack** (1 minute)
   - Show architecture
   - Explain Flask backend
   - Explain database

## 📝 Final Submission Package

```
Required Files:
├── APK File (Google Drive link)
├── PowerPoint Presentation
├── GitHub Repository (public)
├── README.md
├── Source Code (all files)
├── Documentation
└── Deployment Instructions
```

## ✅ Pre-Submission Checklist

- [ ] Backend tested and working
- [ ] Flutter app tested on device
- [ ] API integration verified
- [ ] APK built and uploaded
- [ ] Google Drive link shared
- [ ] PowerPoint updated with link
- [ ] README complete
- [ ] GitHub repository public
- [ ] All documentation included
- [ ] Demo script prepared

## 🎯 Success Criteria

Judges will evaluate:
- ✅ App functionality (works as described)
- ✅ Code quality (clean, commented, modular)
- ✅ Design (UI/UX professional)
- ✅ Innovation (spam detection angle)
- ✅ Completeness (all features present)
- ✅ Documentation (clear and helpful)

---

**Estimated Total Time**: 15-20 minutes to full submission ready
**Status**: Ready to execute final steps
**Support**: All guides and documentation included

**Let's ship it! 🚀**
