# HIVE Deployment & Testing Checklist

## Pre-Deployment Testing

### Backend Testing
- [ ] Backend starts without errors: `npm run dev`
- [ ] Health check works: `GET http://localhost:5000/api/health`
- [ ] MongoDB connection successful
- [ ] All 6 route files load without errors
- [ ] Test with Postman collection imported and working

### Test Cases
- [ ] Analyze phishing message → Returns spam score ≥30
- [ ] Analyze lottery message → Returns spam score ≥50
- [ ] Analyze financial fraud → Returns spam score ≥40
- [ ] Extract intelligence from messages (phones, emails, banks, amounts, URLs)
- [ ] Generate banking call simulation → 4 conversation stages
- [ ] Generate lottery call simulation → 3 conversation stages
- [ ] Get intelligence report → Aggregates data correctly
- [ ] Get statistics → Shows correct totals and breakdowns

### Flutter App Testing
- [ ] App compiles without errors: `flutter run`
- [ ] All 9 screens navigate properly
- [ ] Dashboard displays mock data correctly
- [ ] API service connects to backend (check logs)
- [ ] Spam Analysis screen sends request and displays results
- [ ] Call Trap screen generates and steps through calls
- [ ] Intelligence Report screen shows data and filtering works
- [ ] All buttons are responsive and styled correctly
- [ ] Theme applies consistently across all screens
- [ ] Text is readable on small/large screens

### Integration Testing
- [ ] Frontend connects to backend successfully
- [ ] API responses appear in Flutter screens
- [ ] Error handling shows graceful messages
- [ ] No crashes when navigating between screens
- [ ] No console errors in backend logs

## Backend Deployment

### Heroku Deployment Steps
1. [ ] Install Heroku CLI: `npm install -g heroku`
2. [ ] Login to Heroku: `heroku login`
3. [ ] Create app: `heroku create hive-backend-<your-name>`
4. [ ] Add MongoDB URI: `heroku config:set MONGODB_URI=<url>`
5. [ ] Add CORS origin: `heroku config:set CORS_ORIGIN=<frontend-url>`
6. [ ] Push code: `git push heroku main`
7. [ ] Check logs: `heroku logs --tail`
8. [ ] Test health endpoint: `curl https://hive-backend-<name>.herokuapp.com/api/health`

### Railway Deployment Steps
1. [ ] Sign up at railway.app
2. [ ] Connect GitHub repository
3. [ ] Add MongoDB connection string in Railway dashboard
4. [ ] Add environment variables
5. [ ] Deploy automatically on git push
6. [ ] Get deployment URL from Railway dashboard

### Environment Variables to Set
```
PORT=5000
NODE_ENV=production
MONGODB_URI=<your-mongodb-url>
CORS_ORIGIN=<your-frontend-url>
SPAM_THRESHOLD=40
```

## Flutter Deployment

### Android APK Build
1. [ ] Update API base URL: `http://<backend-url>/api`
2. [ ] Run: `flutter build apk --release`
3. [ ] APK location: `build/app/outputs/flutter-app-release.apk`
4. [ ] Size check: Typically 40-80 MB
5. [ ] Test on Android device or emulator

### Google Play Store Preparation
1. [ ] Create Google Play Developer account ($25)
2. [ ] Generate signing key: `keytool -genkey -v -keystore`
3. [ ] Sign APK with release key
4. [ ] Create app entry in Play Console
5. [ ] Upload APK
6. [ ] Add screenshots and description
7. [ ] Submit for review (1-3 hour approval)

### APK Distribution for Hackathon
1. [ ] Build release APK
2. [ ] Upload to Google Drive
3. [ ] Generate shareable link
4. [ ] Add link to PowerPoint presentation
5. [ ] Include in project submission

## API Testing with Postman

### Import Collection
1. [ ] Open Postman
2. [ ] Click "Import"
3. [ ] Select `hive-backend/HIVE-API-Postman.json`
4. [ ] Update `base_url` variable to your backend URL
5. [ ] Save variables

### Test All Endpoints
- [ ] GET /api/health → Returns status
- [ ] POST /api/spam-detection/analyze-message → Creates record
- [ ] GET /api/spam-detection/messages → Lists messages
- [ ] POST /api/spam-detection/simulate-call → Generates call
- [ ] GET /api/alerts → Returns alerts
- [ ] GET /api/scammers → Lists scammers
- [ ] GET /api/stats → Shows statistics
- [ ] GET /api/spam-detection/intelligence-report → Generates report

## Performance Verification

### Backend Performance
- [ ] Response time < 200ms for analyze-message
- [ ] Response time < 100ms for GET requests
- [ ] Can handle 100 concurrent requests
- [ ] Memory usage < 200MB
- [ ] CPU usage stable

### Flutter Performance
- [ ] App starts in < 3 seconds
- [ ] Screen transitions smooth (60 fps)
- [ ] No memory leaks
- [ ] Battery drain acceptable
- [ ] Data loads without freezing UI

## Security Checklist

- [ ] No hardcoded credentials in code
- [ ] All secrets in environment variables
- [ ] CORS properly configured
- [ ] HTTPS enabled for production
- [ ] Input validation on all endpoints
- [ ] Error messages don't expose system info
- [ ] Database backups configured
- [ ] Rate limiting implemented (optional)

## Documentation Verification

- [ ] README.md is complete and accurate
- [ ] Setup.md has clear instructions
- [ ] API endpoints documented
- [ ] Code comments explain complex logic
- [ ] Example API requests provided
- [ ] Troubleshooting section included
- [ ] Contact/support info provided

## Final Submission Checklist

### Project Submission
- [ ] GitHub repository public and clean
- [ ] README updated with all features
- [ ] Code is well-commented
- [ ] No large binary files committed
- [ ] .gitignore properly configured
- [ ] All dependencies in package.json/pubspec.yaml
- [ ] Build instructions clear

### Hackathon Submission
- [ ] APK uploaded to Google Drive
- [ ] Shareable link working
- [ ] APK size < 100MB
- [ ] APK tested on Android 5.0+
- [ ] All screens tested and working
- [ ] Demo data visible without backend connection
- [ ] PowerPoint has APK download link
- [ ] Video demo created (optional)

### Presentation Materials
- [ ] PowerPoint presentation ready
- [ ] Architecture diagram included
- [ ] Feature list highlighted
- [ ] Tech stack explained
- [ ] Demo walkthrough planned
- [ ] Time estimate for demo (5-10 min)
- [ ] Fallback plan if demo fails

## Post-Deployment Monitoring

- [ ] Monitor error logs daily
- [ ] Check API response times
- [ ] Verify database backups
- [ ] Monitor server resources
- [ ] Track user analytics
- [ ] Set up alerts for critical issues
- [ ] Plan for scaling if needed

## Sign-Off

- [ ] All tests passed: ___________
- [ ] Backend deployed: ___________
- [ ] APK built and tested: ___________
- [ ] Documentation complete: ___________
- [ ] Ready for submission: ___________

---

**Status**: In Progress
**Last Updated**: [Current Date]
**Deployment Target**: Hackathon Submission
