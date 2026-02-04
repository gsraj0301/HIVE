# HIVE Backend Setup Guide

## Overview
HIVE is a scam detection system with a Node.js/Express backend and Flutter mobile app. The backend provides spam detection, auto-reply simulation, and call simulation services.

## Prerequisites
- Node.js 16+ installed
- MongoDB (local or cloud)
- npm or yarn
- Git

## Installation

### 1. Clone and Setup
```bash
cd hive-backend
npm install
```

### 2. Environment Configuration
Create a `.env` file based on `.env.example`:

```env
# Server
PORT=5000
NODE_ENV=development

# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/hive

# CORS
CORS_ORIGIN=http://localhost:3000,http://10.0.2.2:3000

# Spam Detection Thresholds
SPAM_THRESHOLD=40
PHISHING_WEIGHT=30
FRAUD_WEIGHT=40
LOTTERY_WEIGHT=50
```

### 3. MongoDB Setup

#### Option A: Local MongoDB
```bash
# On Windows with MongoDB installed
mongod
```

#### Option B: MongoDB Atlas (Recommended)
1. Go to https://www.mongodb.com/cloud/atlas
2. Create a free cluster
3. Get the connection string
4. Add to `.env` as `MONGODB_URI`

### 4. Start Server
```bash
# Development
npm run dev

# Production
npm start
```

Server will start on `http://localhost:5000`

## API Endpoints

### Spam Detection
- `POST /api/spam-detection/analyze-message` - Analyze email/SMS
- `GET /api/spam-detection/messages` - List analyzed messages
- `GET /api/spam-detection/messages/:id` - Get message details
- `GET /api/spam-detection/stats` - Get statistics

### Auto-Reply System
- `POST /api/spam-detection/auto-reply` - Create auto-reply
- `POST /api/spam-detection/auto-reply/:messageId/follow-up` - Record follow-up

### Call Simulation
- `POST /api/spam-detection/simulate-call` - Generate call simulation
- `POST /api/spam-detection/simulate-call/:id/record` - Record user response
- `GET /api/spam-detection/calls` - List simulations

### Intelligence Reports
- `GET /api/spam-detection/intelligence-report` - Generate official report
- `GET /api/spam-detection/stats` - System statistics

## Testing with Postman

### 1. Analyze Message
```json
POST http://localhost:5000/api/spam-detection/analyze-message
Content-Type: application/json

{
  "content": "Congratulations! You won ₹50 lakhs in our lottery. Click here to claim",
  "messageType": "SMS",
  "sender": "+919876543210",
  "subject": "Lottery Winner"
}
```

### 2. Start Call Simulation
```json
POST http://localhost:5000/api/spam-detection/simulate-call
Content-Type: application/json

{
  "scamType": "banking"
}
```

### 3. Get Intelligence Report
```
GET http://localhost:5000/api/spam-detection/intelligence-report?days=7
```

## Flutter App Configuration

### Update API Base URL in lib/services/api_service.dart

```dart
// For local development
static const String baseUrl = 'http://localhost:5000/api';

// For Android emulator
static const String baseUrl = 'http://10.0.2.2:5000/api';

// For production
static const String baseUrl = 'https://your-backend-url.com/api';
```

## Deployment

### Heroku Deployment

1. **Create Heroku Account**
   - Go to https://www.heroku.com
   - Sign up free

2. **Install Heroku CLI**
   ```bash
   npm install -g heroku
   ```

3. **Deploy**
   ```bash
   heroku login
   heroku create your-app-name
   git push heroku main
   ```

4. **Set Environment Variables**
   ```bash
   heroku config:set MONGODB_URI=<your-mongodb-url>
   heroku config:set CORS_ORIGIN=<your-flutter-app-url>
   ```

5. **View Logs**
   ```bash
   heroku logs --tail
   ```

### Railway Deployment

1. **Sign Up** at https://railway.app
2. **Connect Git Repository**
3. **Set Environment Variables** in Railway Dashboard
4. **Deploy** - Automatic on git push

### AWS/Google Cloud Deployment

1. **Create Cloud Function or Cloud Run**
2. **Upload backend code**
3. **Set environment variables**
4. **Deploy**

## Database Schema

### SpamMessage
- `_id`: ObjectId
- `messageType`: EMAIL | SMS
- `content`: String
- `sender`: String
- `spamScore`: Number (0-100)
- `spamType`: String (Phishing, Financial Fraud, etc.)
- `extractedPhoneNumbers`: [String]
- `extractedEmails`: [String]
- `extractedBanks`: [String]
- `extractedAmounts`: [String]
- `extractedUrls`: [String]
- `isSuspicious`: Boolean
- `createdAt`: Date

### AutoReply
- `_id`: ObjectId
- `messageId`: ObjectId (ref: SpamMessage)
- `reply`: String
- `stage`: String
- `followUpReplies`: [String]
- `createdAt`: Date

### CallSimulation
- `_id`: ObjectId
- `scamType`: String (banking, lottery, investment)
- `conversation`: Array of conversation stages
- `techniquesUsed`: [String]
- `userResponses`: Array of responses
- `estimatedDuration`: Number
- `createdAt`: Date

### OfficialReport
- `_id`: ObjectId
- `reportType`: String
- `periodDays`: Number
- `totalMessages`: Number
- `spamTypes`: Object (type -> count)
- `topPhoneNumbers`: Object
- `topEmails`: Object
- `suspiciousUrls`: [String]
- `createdAt`: Date

## Spam Detection Algorithm

### Scoring System
- Phishing keywords (2+): +30 points
- Financial fraud keywords (3+): +40 points
- Lottery scam keywords (2+): +50 points
- Banking keywords (2+): +35 points
- URL detected: +20 points
- Urgency language: +15 points
- Combined patterns: +10 points each

### Threshold
Messages with score ≥ 40 flagged as suspicious

### Extracted Intelligence
- Phone numbers (Indian format: +91XXXXXXXXXX, 10 digits)
- Email addresses
- Bank names (HDFC, ICICI, SBI, etc.)
- Currency amounts (₹, $, €, £)
- URLs

## Performance Optimization

### Database Indexes
```javascript
// spamMessage collection
db.spasmessages.createIndex({ "spamType": 1 });
db.spasmessages.createIndex({ "isSuspicious": 1 });
db.spasmessages.createIndex({ "createdAt": -1 });

// Auto-reply collection
db.autoreplies.createIndex({ "messageId": 1 });
db.autoreplies.createIndex({ "createdAt": -1 });
```

### Caching
- Cache spam patterns in memory
- Cache analysis results for 1 hour
- Implement Redis for production

## Troubleshooting

### MongoDB Connection Error
```
Error: connect ECONNREFUSED 127.0.0.1:27017
```
- Ensure MongoDB is running: `mongod`
- Check MONGODB_URI in .env
- Verify network access in MongoDB Atlas

### CORS Error
- Check CORS_ORIGIN in .env matches Flutter app URL
- For mobile: use `http://10.0.2.2:5000` for Android emulator
- For web: use `http://localhost:5000`

### Port Already in Use
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9  # macOS/Linux
netstat -ano | findstr :5000   # Windows
```

## Production Checklist

- [ ] Use environment-specific configs
- [ ] Enable HTTPS
- [ ] Set up rate limiting
- [ ] Implement proper authentication (JWT)
- [ ] Add request validation
- [ ] Set up logging (Winston, Morgan)
- [ ] Configure CORS properly
- [ ] Use environment variables for secrets
- [ ] Test all endpoints with real data
- [ ] Set up database backups
- [ ] Monitor error rates
- [ ] Implement caching strategy
- [ ] Use connection pooling for database

## Support

For issues or questions:
1. Check logs: `npm run dev` (development)
2. Test endpoints with Postman
3. Verify environment variables
4. Check MongoDB connection
5. Review error messages in console

## License

MIT
