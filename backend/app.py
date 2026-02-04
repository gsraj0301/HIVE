from flask import Flask, request, jsonify
from flask_cors import CORS
from scam_analysis import ScamAnalysisEngine
import json
import os

app = Flask(__name__)
CORS(app)

# Initialize analysis engine
engine = ScamAnalysisEngine(
    patterns_path='scam_patterns.json',
    scammers_path='scammers_db.json'
)

@app.route('/', methods=['GET'])
def root():
    """Root endpoint - API welcome page"""
    return jsonify({
        "message": "HIVE Scam Detection API",
        "status": "running",
        "version": "1.0.0",
        "endpoints": {
            "health": "/api/health",
            "analyze-call": "POST /api/analyze-call",
            "extract-keywords": "POST /api/extract-keywords",
            "detect-patterns": "POST /api/detect-patterns",
            "calculate-risk": "POST /api/calculate-risk",
            "get-scammers": "GET /api/scammers",
            "intelligence-report": "GET /api/intelligence-report",
            "get-patterns": "GET /api/patterns",
            "search-scammers": "GET /api/scammers/search",
            "get-alerts": "GET /api/alerts"
        }
    })

@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "service": "HIVE Scam Detection API",
        "version": "1.0.0"
    })

@app.route('/api/analyze-call', methods=['POST'])
def analyze_call():
    """Analyze call transcript for scam indicators"""
    try:
        data = request.json
        transcript = data.get('transcript', '')
        scammer_id = data.get('scammer_id')
        
        if not transcript:
            return jsonify({"error": "Transcript is required"}), 400
        
        analysis = engine.analyze_call(transcript, scammer_id)
        
        return jsonify({
            "success": True,
            "analysis": analysis
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/extract-keywords', methods=['POST'])
def extract_keywords():
    """Extract keywords from text"""
    try:
        data = request.json
        text = data.get('text', '')
        
        if not text:
            return jsonify({"error": "Text is required"}), 400
        
        keywords = engine.extract_keywords(text)
        
        return jsonify({
            "success": True,
            "keywords": keywords,
            "count": len(keywords)
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/detect-patterns', methods=['POST'])
def detect_patterns():
    """Detect scam patterns in transcript"""
    try:
        data = request.json
        transcript = data.get('transcript', '')
        
        if not transcript:
            return jsonify({"error": "Transcript is required"}), 400
        
        patterns, scores = engine.detect_scam_patterns(transcript)
        
        return jsonify({
            "success": True,
            "patterns": patterns,
            "pattern_scores": scores,
            "pattern_count": len(patterns)
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/calculate-risk', methods=['POST'])
def calculate_risk():
    """Calculate risk score and level"""
    try:
        data = request.json
        transcript = data.get('transcript', '')
        
        if not transcript:
            return jsonify({"error": "Transcript is required"}), 400
        
        patterns, _ = engine.detect_scam_patterns(transcript)
        risk_score = engine.calculate_risk_score(transcript, patterns)
        risk_level = engine.determine_risk_level(risk_score)
        
        return jsonify({
            "success": True,
            "risk_score": risk_score,
            "risk_level": risk_level,
            "detected_patterns": patterns
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/scammers', methods=['GET'])
def get_scammers():
    """Get all known scammers"""
    try:
        scammers = engine.get_all_scammers()
        
        return jsonify({
            "success": True,
            "scammers": scammers,
            "total": len(scammers)
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/scammers/<scammer_id>', methods=['GET'])
def get_scammer(scammer_id):
    """Get specific scammer info"""
    try:
        scammer = engine.get_scammer_info(scammer_id)
        
        if not scammer:
            return jsonify({"error": "Scammer not found"}), 404
        
        return jsonify({
            "success": True,
            "scammer": scammer
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/intelligence-report', methods=['GET'])
def intelligence_report():
    """Get intelligence report"""
    try:
        report = engine.generate_intelligence_report()
        
        return jsonify({
            "success": True,
            "report": report
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/scam-patterns', methods=['GET'])
def get_scam_patterns():
    """Get all known scam patterns"""
    try:
        patterns = engine.patterns.get('scam_patterns', [])
        
        return jsonify({
            "success": True,
            "patterns": patterns,
            "total": len(patterns)
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/sentiment-analysis', methods=['POST'])
def sentiment_analysis():
    """Analyze sentiment of call"""
    try:
        data = request.json
        text = data.get('text', '')
        
        if not text:
            return jsonify({"error": "Text is required"}), 400
        
        sentiment = engine.extract_sentiment(text)
        
        return jsonify({
            "success": True,
            "sentiment": sentiment
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/alerts', methods=['GET'])
def get_alerts():
    """Get active alerts based on scammer activity"""
    try:
        scammers = engine.get_all_scammers()
        
        alerts = []
        for scammer in scammers:
            if scammer.get('riskLevel') in ['Critical', 'High']:
                alerts.append({
                    "id": f"alert_{scammer['id']}",
                    "type": scammer.get('scamType', 'Unknown'),
                    "title": f"Alert: {scammer['name']} ({scammer['riskLevel']})",
                    "description": scammer.get('description', ''),
                    "severity": scammer.get('riskLevel'),
                    "timestamp": scammer.get('lastSeen', ''),
                    "actionItems": scammer.get('knownPatterns', [])
                })
        
        return jsonify({
            "success": True,
            "alerts": alerts,
            "total": len(alerts)
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("HIVE Scam Detection API Starting...")
    print("Endpoints available at http://localhost:5000")
    app.run(debug=True, host='0.0.0.0', port=5000)
