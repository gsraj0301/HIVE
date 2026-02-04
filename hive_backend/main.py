from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta
import json

# Initialize FastAPI app
app = FastAPI(
    title="HIVE Backend API",
    description="AI-Powered Scam & Fraud Detection Dashboard",
    version="1.0.0"
)

# Enable CORS for Flutter frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (for development)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================
# MOCK DATA GENERATORS
# ============================================

def get_mock_attacks():
    """Generate mock attack log data"""
    return [
        {
            "id": "log_001",
            "attack_type": "Phishing",
            "description": "ICICI Bank impersonation scam call",
            "timestamp": (datetime.now() - timedelta(hours=1)).isoformat(),
            "severity": "Critical",
            "source_ip": "192.168.1.105",
            "duration": 240,
            "keywords": ["r.kumar@icici", "50000", "ICICI Bank", "UPI ID"]
        },
        {
            "id": "log_002",
            "attack_type": "Phishing",
            "description": "Amazon account suspension fake alert",
            "timestamp": (datetime.now() - timedelta(hours=3)).isoformat(),
            "severity": "High",
            "source_ip": "10.0.0.45",
            "duration": 180,
            "keywords": ["http://amaz0n-verify.xyz", "25000", "Amazon"]
        },
        {
            "id": "log_003",
            "attack_type": "Financial Fraud",
            "description": "Lottery scam with false prize claims",
            "timestamp": (datetime.now() - timedelta(hours=5)).isoformat(),
            "severity": "Critical",
            "source_ip": "172.16.0.20",
            "duration": 300,
            "keywords": ["Rs 5 lakhs", "processing fee", "1234567890@hdfc", "lottery"]
        },
    ]


def get_mock_alerts():
    """Generate mock alert data"""
    return [
        {
            "id": "alert_001",
            "title": "Critical: Scam Attempt Detected",
            "message": "A high-risk scam call from +91-98765-43210 has been intercepted. Honeypot engaged.",
            "severity": "Critical",
            "timestamp": (datetime.now() - timedelta(hours=1)).isoformat(),
            "type": "Phishing/Bank Fraud",
            "is_read": False,
            "source_phone_number": "+91-98765-43210",
            "suggested_actions": ["Block this number", "Report to Cyber Crime", "View extracted keywords"]
        },
        {
            "id": "alert_002",
            "title": "High: Amazon Phishing Attack",
            "message": "Phishing attempt detected. Scammer sent malicious link.",
            "severity": "High",
            "timestamp": (datetime.now() - timedelta(hours=3)).isoformat(),
            "type": "Phishing",
            "is_read": False,
            "source_phone_number": "+91-87654-32109",
            "suggested_actions": ["Report link to Amazon", "Block number"]
        },
    ]


def get_mock_scammers():
    """Generate mock scammer data"""
    return [
        {
            "id": "scammer_01",
            "phone_number": "+91-98765-43210",
            "name": "Rajesh Kumar (Fake)",
            "risk_level": "Critical",
            "call_count": 23,
            "last_seen": (datetime.now() - timedelta(hours=1)).isoformat(),
            "scam_types": ["Bank Fraud", "Phishing", "Account Compromise"],
            "region": "Unknown (Likely Delhi/NCR)",
            "honeypot_active": True
        },
        {
            "id": "scammer_02",
            "phone_number": "+91-87654-32109",
            "name": "Priya Singh (Fake)",
            "risk_level": "High",
            "call_count": 15,
            "last_seen": (datetime.now() - timedelta(hours=3)).isoformat(),
            "scam_types": ["E-commerce Phishing", "Account Theft"],
            "region": "Unknown (Likely Mumbai)",
            "honeypot_active": True
        },
    ]


def get_mock_dashboard_stats():
    """Generate dashboard statistics"""
    attacks = get_mock_attacks()
    alerts = get_mock_alerts()
    scammers = get_mock_scammers()
    
    return {
        "total_attacks_today": 15,
        "attacks_this_week": 89,
        "critical_alerts": len([a for a in alerts if a["severity"] == "Critical"]),
        "active_honeypots": len([s for s in scammers if s["honeypot_active"]]),
        "attack_types": {
            "Phishing": 5,
            "Financial Fraud": 4,
            "Identity Theft": 3,
            "DDoS": 2,
            "SMS Spoofing": 1
        },
        "risk_distribution": {
            "Critical": 4,
            "High": 7,
            "Medium": 3,
            "Low": 1
        },
        "percentage_change": 18.5,  # Percentage increase from yesterday
        "timestamp": datetime.now().isoformat()
    }


# ============================================
# API ENDPOINTS
# ============================================

@app.get("/")
async def root():
    """Root endpoint - API information"""
    return {
        "name": "HIVE Backend API",
        "version": "1.0.0",
        "description": "AI-Powered Scam & Fraud Detection Dashboard",
        "status": "running",
        "timestamp": datetime.now().isoformat()
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    }


@app.get("/dashboard/stats")
async def get_dashboard_stats():
    """Get dashboard statistics"""
    return {
        "success": True,
        "data": get_mock_dashboard_stats()
    }


@app.get("/logs")
async def get_logs(limit: int = 20, offset: int = 0):
    """Get attack logs with pagination"""
    logs = get_mock_attacks()
    return {
        "success": True,
        "data": logs[offset:offset+limit],
        "total": len(logs),
        "timestamp": datetime.now().isoformat()
    }


@app.get("/logs/{log_id}")
async def get_log_detail(log_id: str):
    """Get specific log details"""
    logs = get_mock_attacks()
    log = next((l for l in logs if l["id"] == log_id), None)
    
    if not log:
        return {
            "success": False,
            "error": "Log not found",
            "log_id": log_id
        }
    
    return {
        "success": True,
        "data": log
    }


@app.get("/alerts")
async def get_alerts(limit: int = 20, severity: str = None):
    """Get alerts with optional severity filter"""
    alerts = get_mock_alerts()
    
    if severity:
        alerts = [a for a in alerts if a["severity"].lower() == severity.lower()]
    
    return {
        "success": True,
        "data": alerts[:limit],
        "total": len(alerts),
        "timestamp": datetime.now().isoformat()
    }


@app.get("/scammers")
async def get_scammers(limit: int = 20, risk_level: str = None):
    """Get scammer list with optional risk level filter"""
    scammers = get_mock_scammers()
    
    if risk_level:
        scammers = [s for s in scammers if s["risk_level"].lower() == risk_level.lower()]
    
    return {
        "success": True,
        "data": scammers[:limit],
        "total": len(scammers),
        "timestamp": datetime.now().isoformat()
    }


@app.get("/scammers/{scammer_id}")
async def get_scammer_detail(scammer_id: str):
    """Get specific scammer details"""
    scammers = get_mock_scammers()
    scammer = next((s for s in scammers if s["id"] == scammer_id), None)
    
    if not scammer:
        return {
            "success": False,
            "error": "Scammer not found",
            "scammer_id": scammer_id
        }
    
    return {
        "success": True,
        "data": scammer
    }


@app.post("/analyze-call")
async def analyze_call(call_data: dict):
    """
    Analyze a call and return risk assessment
    
    Expected input:
    {
        "phone_number": "+91-XXXXXXXXXX",
        "transcript": "conversation text",
        "duration": 120,
        "keywords": ["keyword1", "keyword2"]
    }
    """
    try:
        phone_number = call_data.get("phone_number", "")
        transcript = call_data.get("transcript", "")
        duration = call_data.get("duration", 0)
        keywords = call_data.get("keywords", [])
        
        # Simple risk scoring logic
        risk_score = 0
        extracted_keywords = []
        
        # Check for common scam keywords
        scam_patterns = {
            "upi": ["upi", "@", "payment", "transfer"],
            "bank": ["bank", "account", "verify", "confirm"],
            "otp": ["otp", "password", "pin", "security code"],
            "fraud_phrases": ["urgent", "immediate", "suspended", "compromised", "lucky", "prize", "lottery"]
        }
        
        transcript_lower = transcript.lower()
        
        # Extract UPI IDs
        if "@" in transcript:
            upi_ids = [word for word in transcript.split() if "@" in word and len(word) > 3]
            extracted_keywords.extend(upi_ids)
            risk_score += len(upi_ids) * 15
        
        # Check for bank mentions
        banks = ["icici", "hdfc", "sbi", "axis", "kotak", "indusind"]
        for bank in banks:
            if bank in transcript_lower:
                extracted_keywords.append(bank.upper())
                risk_score += 20
        
        # Check for URLs
        urls = [word for word in transcript.split() if word.startswith("http")]
        extracted_keywords.extend(urls)
        risk_score += len(urls) * 25
        
        # Check for fraud phrases
        fraud_count = sum(1 for phrase in scam_patterns["fraud_phrases"] if phrase in transcript_lower)
        risk_score += fraud_count * 10
        
        # Call duration factor
        if duration > 300:
            risk_score += 10
        
        # Determine risk level
        if risk_score >= 60:
            risk_level = "Critical"
        elif risk_score >= 40:
            risk_level = "High"
        elif risk_score >= 20:
            risk_level = "Medium"
        else:
            risk_level = "Low"
        
        return {
            "success": True,
            "data": {
                "phone_number": phone_number,
                "risk_level": risk_level,
                "risk_score": risk_score,
                "extracted_keywords": list(set(extracted_keywords)),
                "recommendation": "Enable honeypot" if risk_level in ["Critical", "High"] else "Monitor",
                "timestamp": datetime.now().isoformat()
            }
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }


@app.post("/start-honeypot")
async def start_honeypot(honeypot_data: dict):
    """
    Start honeypot engagement with a scammer
    
    Expected input:
    {
        "scammer_id": "scammer_01",
        "phone_number": "+91-XXXXXXXXXX",
        "conversation_starter": "How can I help you?"
    }
    """
    try:
        scammer_id = honeypot_data.get("scammer_id", "")
        phone_number = honeypot_data.get("phone_number", "")
        starter = honeypot_data.get("conversation_starter", "")
        
        # Generate honeypot response
        honeypot_responses = [
            "I need to verify your account details. Can you provide your UPI ID?",
            "Thank you for confirming. I'm verifying your account now.",
            "One moment, I'm checking the status with our security team.",
            "For security purposes, can you confirm your registered phone number?",
            "I understand. Let me transfer you to our verified account recovery team.",
        ]
        
        return {
            "success": True,
            "data": {
                "honeypot_session_id": f"honeypot_{scammer_id}_{int(datetime.now().timestamp())}",
                "scammer_id": scammer_id,
                "phone_number": phone_number,
                "status": "active",
                "ai_response": honeypot_responses[0],
                "timestamp": datetime.now().isoformat(),
                "message": "Honeypot engagement started. AI will now communicate with the scammer."
            }
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }


@app.post("/honeypot/respond")
async def honeypot_respond(response_data: dict):
    """
    Get AI response to continue honeypot conversation
    
    Expected input:
    {
        "honeypot_session_id": "honeypot_xyz",
        "user_message": "message from scammer"
    }
    """
    try:
        session_id = response_data.get("honeypot_session_id", "")
        user_message = response_data.get("user_message", "")
        
        # Simulate AI responses based on scammer messages
        ai_responses = {
            "default": "Thank you for waiting. I'm verifying the information with our system.",
            "ask_upi": "Could you please provide the UPI ID registered with your account?",
            "ask_otp": "For security verification, can you provide the OTP sent to your registered number?",
            "confirm": "I'm confirming the details. Please hold while I process this.",
        }
        
        # Simple keyword detection for response selection
        user_lower = user_message.lower()
        
        if any(word in user_lower for word in ["upi", "pay", "transfer"]):
            response = ai_responses["ask_upi"]
        elif any(word in user_lower for word in ["otp", "password", "code"]):
            response = ai_responses["ask_otp"]
        elif any(word in user_lower for word in ["yes", "ok", "confirm"]):
            response = ai_responses["confirm"]
        else:
            response = ai_responses["default"]
        
        return {
            "success": True,
            "data": {
                "honeypot_session_id": session_id,
                "ai_response": response,
                "keywords_detected": extract_keywords_from_message(user_message),
                "timestamp": datetime.now().isoformat()
            }
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }


def extract_keywords_from_message(message: str) -> list:
    """Extract suspicious keywords from a message"""
    keywords = []
    
    # UPI ID pattern
    if "@" in message:
        parts = message.split()
        upi_ids = [p for p in parts if "@" in p and len(p) > 3]
        keywords.extend(upi_ids)
    
    # Banks
    banks = ["icici", "hdfc", "sbi", "axis", "kotak"]
    for bank in banks:
        if bank in message.lower():
            keywords.append(bank.upper())
    
    # URLs
    urls = [word for word in message.split() if word.startswith("http")]
    keywords.extend(urls)
    
    # Phone numbers (simple pattern)
    import re
    phone_pattern = r'\b\d{10,}\b'
    phones = re.findall(phone_pattern, message)
    keywords.extend(phones)
    
    return list(set(keywords))


@app.post("/alert")
async def create_alert(alert_data: dict):
    """Create a new alert"""
    try:
        return {
            "success": True,
            "data": {
                "id": f"alert_{int(datetime.now().timestamp())}",
                "title": alert_data.get("title", ""),
                "message": alert_data.get("message", ""),
                "severity": alert_data.get("severity", "Medium"),
                "timestamp": datetime.now().isoformat(),
                "message": "Alert created successfully"
            }
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }


@app.get("/stats/summary")
async def get_summary_stats():
    """Get summary statistics for dashboard"""
    stats = get_mock_dashboard_stats()
    return {
        "success": True,
        "data": {
            "total_attacks": stats["total_attacks_today"],
            "critical_alerts": stats["critical_alerts"],
            "active_honeypots": stats["active_honeypots"],
            "trend": "increasing" if stats["percentage_change"] > 0 else "decreasing",
            "percentage_change": stats["percentage_change"],
            "timestamp": datetime.now().isoformat()
        }
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
