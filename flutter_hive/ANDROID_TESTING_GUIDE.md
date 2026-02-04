# HIVE Scam Detection App - Android Testing Guide

## Prerequisites

### 1. **Android Studio Installation**
- Download from: https://developer.android.com/studio
- Ensure you have:
  - Android SDK (API Level 21+)
  - Android Virtual Device (AVD) Emulator or Physical Device

### 2. **Flutter SDK Setup**
- Verify Flutter is installed: `flutter --version`
- Check Android setup: `flutter doctor`
- Ensure all Android dependencies are installed

---

## How to Run the App in Android Studio

### **Option A: Using Android Emulator (Recommended for Testing)**

1. **Open Android Studio**
   - Launch Android Studio
   - Open the project: `File > Open > /path/to/flutter_hive`

2. **Create or Start an Android Virtual Device (AVD)**
   - Click `Tools > Device Manager`
   - Create a new device or start an existing one
   - Select a device (e.g., Pixel 6 with Android 13+)
   - Click "Play" to start the emulator

3. **Run the App**
   - In VS Code Terminal (in the project directory):
     ```bash
     flutter run
     ```
   - Or in Android Studio:
     - Click `Run > Run 'app'` (or press Shift+F10)

4. **Wait for Build**
   - First build takes 2-5 minutes
   - Subsequent builds are faster due to caching

---

### **Option B: Using Physical Android Device**

1. **Enable Developer Mode**
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
   - Go to Settings > Developer Options
   - Enable "USB Debugging"

2. **Connect Device via USB**
   - Connect your Android phone via USB cable
   - Select "File Transfer" mode when prompted

3. **Run the App**
   ```bash
   flutter run
   ```

---

## Testing the Application

### **1. Dashboard Screen (Home)**
- **What to Test:**
  - View attack statistics and charts
  - See "Total Attacks Today" counter (currently showing: 4)
  - Check "Attack Activity" bar chart
  - Toggle between time periods: Today, Week, Month
  
- **Expected Behavior:**
  - Smooth animations and transitions
  - Chart bars should display with gradient colors (blue to cyan)
  - Attack type badges should show counts

- **Test Steps:**
  1. Launch the app - you should see the Dashboard immediately
  2. Click "Week" or "Month" buttons to see period toggle
  3. Scroll down to see all sections
  4. Verify all icons and text are visible

---

### **2. Logs Screen**
- **What to Test:**
  - View detailed attack logs and incidents
  - See attack types, timestamps, and descriptions
  - Filter or sort functionality (if implemented)

- **Test Steps:**
  1. Tap the Logs icon in the bottom navigation
  2. Scroll through the list of attacks
  3. Verify each log shows: attack type, description, timestamp, severity

---

### **3. Call Simulation Screen**
- **What to Test:**
  - Simulate incoming scam calls
  - Test call blocking features
  - Verify detection accuracy

- **Test Steps:**
  1. Tap the Call Simulation icon
  2. Try simulating different types of scam calls
  3. Check if alerts are triggered

---

### **4. Scammers Screen**
- **What to Test:**
  - View list of known scammer contacts
  - Check contact blocking features
  - Review scammer profiles

- **Test Steps:**
  1. Tap the Scammers icon
  2. Review the list of flagged numbers
  3. Check if blocking functionality works

---

### **5. Alerts Screen**
- **What to Test:**
  - View active security alerts
  - Check notification system
  - Test alert dismissal

- **Test Steps:**
  1. Tap the Alerts icon
  2. Review unread alerts (currently showing: 3)
  3. Test if you can interact with alerts

---

### **6. Settings Screen**
- **What to Test:**
  - User preferences and configuration
  - Theme settings (already dark theme applied)
  - Notification settings

- **Test Steps:**
  1. Tap the Settings icon
  2. Explore available options
  3. Verify settings persist after app restart

---

## UI/UX Testing Checklist

### **Visual Design**
- ✅ Dark theme applied consistently throughout
- ✅ Cybersecurity color scheme (Purple/Blue/Cyan)
- ✅ Responsive layout on different screen sizes
- ✅ All icons display correctly

### **Functionality**
- ✅ Bottom navigation works (6 screens)
- ✅ No crashes on screen transitions
- ✅ Data loads correctly (mock data)
- ✅ Animations are smooth

### **Performance**
- Check app launch time (should be < 3 seconds)
- Monitor memory usage (should stay under 150MB)
- Test with network conditions (if applicable)

---

## Debugging Tips

### **1. View Logs During Run**
```bash
flutter logs
```
- Shows all debug output and errors

### **2. Hot Reload During Development**
```bash
flutter run
# Then press 'r' in terminal to hot reload
```
- Makes code changes appear instantly without rebuild

### **3. Hot Restart**
```bash
# Press 'R' in terminal to hot restart
```
- Fully restarts the app (slower than hot reload)

### **4. Android Studio Debugger**
- Set breakpoints in code
- Run with debugging: `flutter run -d <device_id> --start-paused`
- Step through code execution

---

## Troubleshooting

### **App Won't Run**
```bash
flutter clean
flutter pub get
flutter run
```

### **Build Fails**
```bash
# Clear all build artifacts
rm -r build/
flutter pub get
flutter run
```

### **Emulator Not Detected**
```bash
# List available devices
flutter devices

# If empty, restart adb
adb kill-server
adb start-server
```

### **Slow Performance**
- Use a higher-end emulator (Pixel 6/7)
- Enable GPU acceleration in AVD settings
- Close other applications

---

## Testing Scenarios

### **Scenario 1: Normal User Flow**
1. Launch app → See Dashboard
2. Navigate through all screens
3. Return to Dashboard
4. Close and reopen app

### **Scenario 2: Data Display**
1. Check if mock data loads correctly
2. Verify numbers match expectations
3. Test with different time periods

### **Scenario 3: Performance**
1. Measure app startup time
2. Test smoothness of animations
3. Monitor memory during navigation

### **Scenario 4: Responsiveness**
1. Test on different screen sizes (4.5", 5.5", 6.5")
2. Test in portrait and landscape modes
3. Verify text scales appropriately

---

## Demo Features to Highlight

1. **Cybersecurity Dashboard**: Real-time attack statistics
2. **Dark Theme UI**: Modern, eye-friendly interface
3. **Attack Classification**: Phishing, DDoS, Malware, Fraud, etc.
4. **Severity Indicators**: Critical, High, Medium badges
5. **Responsive Design**: Works on all Android devices
6. **Navigation**: Smooth bottom tab navigation

---

## Next Steps

1. ✅ Run the app on Android emulator/device
2. ✅ Test all navigation flows
3. ✅ Verify visual design consistency
4. ✅ Check performance metrics
5. 📋 Gather feedback on UI/UX
6. 📋 Implement backend integration (when ready)

---

## Contact & Support

For issues or questions, refer to:
- Flutter Docs: https://flutter.dev
- Android Studio Docs: https://developer.android.com/studio
- Project Repository: (Add your repo link here)
