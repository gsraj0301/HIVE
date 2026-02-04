# Running HIVE App on Android Emulator - Complete Guide

## Current Status
- ✅ Android SDK installed and ready
- ✅ Emulator available (IPHONE device)
- ⚠️ Emulator currently offline - needs to be properly booted

---

## Method 1: Launch via Android Studio (Recommended)

### Step 1: Open Android Studio
1. Launch **Android Studio**
2. Go to **File → Open** → Select your `flutter_hive` project folder
3. Android Studio will auto-detect it as a Flutter project

### Step 2: Start the Emulator
1. Click **Tools → Device Manager** (or press Ctrl+Alt+D)
2. You'll see the "IPHONE" emulator listed
3. Click the green **▶ Play button** next to it
4. Wait 30-60 seconds for the emulator to fully boot
   - You should see the Android home screen appear
   - Status will change from "Offline" to "Online"

### Step 3: Run the App
Once the emulator is online:

**Option A - Using VS Code Terminal:**
```bash
cd C:\Users\danse\OneDrive\ドキュメント\HIVE-PROJECT\flutter_hive
flutter run
```

**Option B - Using Android Studio:**
1. In Android Studio, go to **Run → Run 'app'** (or press Shift+F10)
2. Select the "IPHONE" emulator when prompted
3. App will build and launch

### Step 4: Wait for Build
- **First build**: 2-5 minutes (downloads dependencies)
- **Subsequent builds**: 30-60 seconds
- Watch the terminal for progress messages

---

## Method 2: Command Line (If Android Studio not available)

```bash
# 1. Navigate to project
cd C:\Users\danse\OneDrive\ドキュメント\HIVE-PROJECT\flutter_hive

# 2. Clean previous builds
flutter clean

# 3. Get dependencies
flutter pub get

# 4. List available devices
flutter devices

# 5. Run on default device (will prompt if multiple available)
flutter run

# Or run with verbose output to see all details
flutter run -v
```

---

## How to Test the App (Once Running)

### Visual Inspection ✓
1. **Check Theme**
   - Dark purple/blue theme should be applied
   - All text should be white/light colored
   - Background should be very dark

2. **Check Layout**
   - 6 icons at the bottom (Dashboard, Logs, Call, Scammers, Alerts, Settings)
   - All content should be within screen bounds
   - No overlapping text or cut-off elements

### Navigation Testing ✓
| Icon | Screen | Test |
|------|--------|------|
| 📊 | Dashboard | Tap it - should show attack stats, charts, and recent attacks |
| 📝 | Logs | Tap it - should show list of attack logs |
| ☎️ | Call Simulation | Tap it - simulate incoming calls |
| 👤 | Scammers | Tap it - see known scammer numbers |
| 🔔 | Alerts | Tap it - view security alerts |
| ⚙️ | Settings | Tap it - access app settings |

**Test Steps:**
1. Launch the app
2. Wait for Dashboard to load (should see immediately)
3. **Tap each bottom icon one by one**
4. Verify each screen loads without crashes
5. Go back to Dashboard by tapping 📊

### Dashboard Screen Testing ✓
This is the main feature to test thoroughly:

**Elements to Verify:**
```
┌─────────────────────────────────────┐
│ HIVE - Scam Detection      (3)       │  ← Title + notification count
├─────────────────────────────────────┤
│ [Ask anything you need...]    🤖    │  ← Search bar
├─────────────────────────────────────┤
│ Attack Activity                     │  ← Section title
│ [Today] Week  Month                 │  ← Period toggle buttons
│                                     │
│ ┌─────────────────────────────────┐ │
│ │   Chart (bar graph)     Mon-Sat  │ │  ← Attack chart
│ └─────────────────────────────────┘ │
│                                     │
│ Total Attacks Today: 4              │  ← Statistics
│ 📈 +18%                             │
│                                     │
│ Attack Types:                       │  ← Badges
│ 🔷 Phishing (3)                     │
│ 💰 Financial Fraud (1)              │
│ 👤 Identity Theft (1)               │
│ ☁️ DDoS Attack (1)                  │
│ 🐛 Malware (1)                      │
│ 📱 SMS Spoofing (1)                 │
│                                     │
│ Recent Attacks:                     │  ← Attack list
│ 📧 Phishing - CRITICAL              │
│ 📧 Phishing - HIGH                  │
│ 💰 Financial Fraud - CRITICAL       │
└─────────────────────────────────────┘
```

**Test Interactions:**
1. **Toggle Time Periods**
   - Tap "Week" - chart should update
   - Tap "Month" - chart should update
   - Tap "Today" - return to original
   - Should see smooth transitions

2. **Scroll Content**
   - Scroll down on Dashboard
   - All attack types should be visible
   - All recent attacks should be accessible
   - No jittery scrolling

3. **Check Numbers**
   - Verify "4" total attacks displays correctly
   - Verify individual attack type counts add up
   - Verify "+18%" trend indicator displays

### Performance Testing ✓
1. **Launch Time**
   - Time from app start to Dashboard visible
   - Should be < 3 seconds on average

2. **Navigation Speed**
   - Each screen should load instantly
   - No lag when tapping bottom icons
   - Smooth transitions between screens

3. **Scroll Performance**
   - Dashboard should scroll smoothly
   - No dropped frames or stuttering
   - Animations should be fluid

4. **Memory Usage**
   - Emulator might show ~150-250MB RAM usage
   - Should stay stable (not constantly increasing)
   - Check via: Logcat tab in Android Studio

### Functionality Testing ✓

**Test Cases:**

| Test Case | Steps | Expected Result |
|-----------|-------|-----------------|
| App launches | Run app | Dashboard shows immediately |
| Navigation works | Tap each icon | Each screen loads smoothly |
| Data displays | Check Dashboard | Shows 4 attacks, all types visible |
| Scrolling works | Scroll Dashboard | Content moves smoothly, no lag |
| Period toggle | Click Week/Month | Chart updates |
| Theme applies | Look at colors | Dark purple theme throughout |
| No crashes | Use app 2 mins | No error dialogs |
| Return from other screens | Tap icon, go back | Dashboard intact |

### Bug Testing ✓
While testing, watch for:
- ❌ **Red errors** in top-right corner
- ❌ **Black crash screens** 
- ❌ **Hanging/frozen UI**
- ❌ **Text overlapping**
- ❌ **Icons not loading**
- ❌ **Missing data**
- ❌ **Slow performance**

If you see any of these, check the terminal output for error messages.

---

## Debugging While Running

### View Logs in Real-Time
```bash
flutter logs
```
Shows all app output, errors, and warnings as you interact with the app.

### Hot Reload (Live Code Updates)
While `flutter run` is active:
```
Press 'r' to hot reload
```
Instantly applies code changes without rebuilding!

### Hot Restart (Full Restart)
```
Press 'R' to hot restart
```
Fully restarts the app (slower than reload).

### Stop the App
```
Press 'q' to quit
```

---

## Emulator Controls

### In the Emulator Window:
- **Back button** (← arrow): Go back
- **Home button** (⭕): Return to home
- **Recent apps** (≡ menu): Show recent apps
- **Volume buttons**: Control volume
- **Power button**: Lock/unlock screen

### Useful Emulator Features:
1. **Rotate screen**: Press Ctrl+F12 or click rotation button
2. **Zoom**: Ctrl+Scroll or click zoom controls
3. **Performance**: Settings → Advanced → Check GPU acceleration enabled
4. **Screenshot**: From emulator menu or `adb shell screencap`

---

## Testing Checklist

### Pre-Launch
- [ ] Emulator is running (online status)
- [ ] Project is in project folder
- [ ] No pending file changes

### During Build
- [ ] Terminal shows "gradle" tasks running
- [ ] No build errors appear
- [ ] Build completes with "success" message

### After Launch
- [ ] App appears on emulator screen
- [ ] Dashboard loads automatically
- [ ] No error messages in top-right

### During Usage
- [ ] All 6 navigation screens accessible
- [ ] Dashboard shows correct data (4 attacks, 6 types)
- [ ] Smooth scrolling on Dashboard
- [ ] Time period toggle works (Today/Week/Month)
- [ ] Severity badges display (Critical/High)
- [ ] No crashes during 2-minute usage

### Performance
- [ ] App starts in < 3 seconds
- [ ] Navigation between screens is instant
- [ ] Scrolling is smooth without stuttering
- [ ] Memory stays reasonable (< 300MB)

---

## Troubleshooting

### Problem: Emulator stuck offline
**Solution:**
```bash
# Kill and restart emulator
adb kill-server
adb start-server
flutter devices  # Should show online now
```

### Problem: "gradle failed" build error
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Problem: App crashes immediately
**Solution:**
1. Check terminal for error messages
2. Run with verbose: `flutter run -v`
3. Look for the red X error logs

### Problem: Emulator too slow
**Solution:**
1. Close other applications
2. In emulator: Settings → About → Verify API Level 30+
3. Enable GPU acceleration: Device Manager → Edit → Advanced → GPU enabled

### Problem: "No devices found"
**Solution:**
```bash
# Restart ADB (Android Debug Bridge)
adb kill-server
adb start-server

# List devices again
flutter devices

# Or launch emulator manually first:
flutter emulators --launch IPHONE
# Wait 60 seconds
flutter devices
```

---

## Next Steps After Testing

1. ✅ Verify app launches without errors
2. ✅ Test all 6 screens navigation
3. ✅ Confirm Dashboard shows correct data
4. ✅ Check performance is smooth
5. 📋 Test on physical Android device (if available)
6. 📋 Get feedback from team
7. 📋 Plan next features

---

## Common Questions

**Q: Why does first build take so long?**
A: Gradle downloads all dependencies and compiles everything. Subsequent builds are much faster.

**Q: Can I test on my real phone instead?**
A: Yes! Enable USB debugging in phone settings, connect via USB, and `flutter run` will use it.

**Q: How do I stop the app?**
A: Press 'q' in the terminal where `flutter run` is active.

**Q: Can I see console logs?**
A: Yes! `flutter logs` shows all output while app is running.

**Q: Is the app data real?**
A: No, it's using mock data (hardcoded test data). Backend integration is not yet implemented.

