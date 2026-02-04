# HIVE Backend API

AI-Powered Scam & Fraud Detection Dashboard Backend

## Setup & Installation

### Prerequisites
- Python 3.8+
- pip

### Installation Steps

1. **Create a virtual environment (recommended)**
   ```bash
   python -m venv venv
   
   # On Windows
   venv\Scripts\activate
   
   # On macOS/Linux
   source venv/bin/activate
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the server**
   ```bash
   python main.py
   ```
   
   The server will start at `http://localhost:8000`

## API Documentation

Once the server is running, visit:
- **API Docs (Swagger UI)**: `http://localhost:8000/docs`
- **Alternative Docs (ReDoc)**: `http://localhost:8000/redoc`

## Available Endpoints

### Dashboard
- `GET /dashboard/stats` - Get dashboard statistics
- `GET /stats/summary` - Get summary statistics

### Logs
- `GET /logs?limit=20&offset=0` - Get attack logs with pagination
- `GET /logs/{log_id}` - Get specific log details

### Alerts
- `GET /alerts?limit=20&severity=Critical` - Get alerts with optional filtering
- `POST /alert` - Create a new alert

### Scammers
- `GET /scammers?limit=20&risk_level=Critical` - Get scammer list
- `GET /scammers/{scammer_id}` - Get scammer details

### Scam Analysis & Honeypot
- `POST /analyze-call` - Analyze a call for scam risk
- `POST /start-honeypot` - Start AI honeypot engagement
- `POST /honeypot/respond` - Get AI response for honeypot conversation

### Health Check
- `GET /health` - Health check endpoint
- `GET /` - API information

## Example Request/Response

### Analyze Call
**Request:**
```json
POST /analyze-call
{
  "phone_number": "+91-98765-43210",
  "transcript": "Hello sir, I am from ICICI Bank. Your account has been compromised. Please verify your UPI ID r.kumar@icici",
  "duration": 240,
  "keywords": []
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "phone_number": "+91-98765-43210",
    "risk_level": "Critical",
    "risk_score": 85,
    "extracted_keywords": ["r.kumar@icici", "ICICI"],
    "recommendation": "Enable honeypot",
    "timestamp": "2024-02-04T10:30:00"
  }
}
```

## Mock Data Features

The backend uses in-memory mock data that includes:
- Attack logs with extracted keywords
- Alerts with severity levels
- Scammer profiles with honeypot status
- Call analysis with keyword extraction
- Dashboard statistics

All data is generated dynamically and persists only during the server session.

## Architecture

```
hive_backend/
├── main.py              # FastAPI application with all endpoints
├── requirements.txt     # Python dependencies
└── README.md           # This file
```

## Features

1. **Dashboard Statistics** - Real-time attack counts and trends
2. **Attack Log Analysis** - Detailed logs with keyword extraction
3. **Alert Management** - Severity-based alert filtering
4. **Scammer Tracking** - Database of known scammers
5. **Call Risk Analysis** - Automatic keyword extraction and risk scoring
6. **AI Honeypot Controller** - Simulated responses to engage scammers

## Keyword Extraction

The system automatically extracts:
- UPI IDs (format: `name@upi`)
- Bank names
- Phishing URLs
- Phone numbers
- Common scam phrases

## Future Enhancements

- Database integration (SQLite/PostgreSQL)
- Real-time call analysis
- Machine learning models for scam detection
- Integration with law enforcement APIs
- Advanced honeypot AI responses

## Notes

- This is a **hackathon prototype** - not for production use
- All data is mock/demo data
- The system is designed for **defensive security only**
- No real financial transactions occur

## Support

For issues or questions, please refer to the main HIVE project documentation.
