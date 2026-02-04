import json
import os
from datetime import datetime
from collections import Counter
import re
import math

class ScamAnalysisEngine:
    """Real data processing engine for scam call analysis"""
    
    def __init__(self, patterns_path='scam_patterns.json', scammers_path='scammers_db.json'):
        self.patterns = self.load_json(patterns_path)
        self.scammers = self.load_json(scammers_path)
        self.stop_words = {
            'the', 'is', 'at', 'which', 'on', 'a', 'an', 'and', 'or', 'but',
            'in', 'with', 'to', 'for', 'of', 'from', 'by', 'as', 'be', 'been',
            'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
            'should', 'may', 'might', 'can', 'i', 'you', 'he', 'she', 'it', 'we',
            'they', 'me', 'him', 'her', 'us', 'them', 'my', 'your', 'his', 'its'
        }
        
    @staticmethod
    def load_json(filepath):
        """Load JSON file"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                return json.load(f)
        except:
            return []
    
    def extract_keywords(self, text):
        """Extract meaningful keywords from transcript using real NLP"""
        # Convert to lowercase and remove special characters
        text = text.lower()
        
        # Remove punctuation and split
        words = re.findall(r'\b\w+\b', text)
        
        # Remove stop words
        keywords = [w for w in words if w not in self.stop_words and len(w) > 3]
        
        # Extract email-like patterns
        emails = re.findall(r'[a-z0-9._%+-]+@[a-z0-9.-]+', text)
        keywords.extend(emails)
        
        # Extract phone patterns
        phones = re.findall(r'\+?\d{1,3}-?\d{4,5}-?\d{4,5}', text)
        keywords.extend(phones)
        
        # Extract money amounts
        amounts = re.findall(r'(?:rs|₹)?\s*\d+(?:,\d{3})*(?:\.\d{2})?', text)
        keywords.extend(amounts)
        
        # Extract URLs
        urls = re.findall(r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', text)
        keywords.extend(urls)
        
        # Remove duplicates and return top keywords
        unique_keywords = list(set(keywords))
        return unique_keywords[:20]  # Top 20 keywords
    
    def detect_scam_patterns(self, transcript):
        """Detect scam patterns in transcript"""
        text = transcript.lower()
        detected_patterns = []
        pattern_scores = {}
        
        for pattern in self.patterns.get('scam_patterns', []):
            keywords = pattern.get('keywords', [])
            match_count = sum(1 for kw in keywords if kw.lower() in text)
            
            if match_count > 0:
                # Calculate pattern score based on matches
                pattern_score = (match_count / len(keywords)) * pattern.get('indicatorScore', 0.8)
                detected_patterns.append(pattern['name'])
                pattern_scores[pattern['name']] = pattern_score
        
        return detected_patterns, pattern_scores
    
    def calculate_risk_score(self, transcript, detected_patterns):
        """Calculate overall risk score (0-100)"""
        base_score = 0
        
        # Pattern-based scoring
        for pattern in detected_patterns:
            if pattern == "Phishing Links":
                base_score += 30
            elif pattern == "Credential Theft":
                base_score += 28
            elif pattern == "Account Compromise":
                base_score += 25
            elif pattern == "Legal Threat":
                base_score += 20
            elif pattern == "Urgency/Pressure":
                base_score += 15
            elif pattern == "Financial Threat":
                base_score += 18
            else:
                base_score += 10
        
        # Risk trigger words
        text = transcript.lower()
        for trigger in self.patterns.get('risk_triggers', []):
            word = trigger.get('keyword', '')
            weight = trigger.get('weight', 0.5)
            if word in text:
                base_score += weight * 5
        
        # Cap score at 100
        risk_score = min(base_score, 100)
        return risk_score
    
    def determine_risk_level(self, risk_score):
        """Determine risk level based on score"""
        if risk_score >= 80:
            return "Critical"
        elif risk_score >= 60:
            return "High"
        elif risk_score >= 40:
            return "Medium"
        elif risk_score >= 20:
            return "Low"
        else:
            return "Minimal"
    
    def extract_sentiment(self, text):
        """Simple sentiment analysis"""
        positive_words = ['good', 'great', 'excellent', 'thank', 'thank you', 'appreciate']
        negative_words = ['bad', 'terrible', 'wrong', 'urgent', 'immediately', 'threat', 'block', 'close', 'arrest']
        
        text = text.lower()
        pos_count = sum(1 for word in positive_words if word in text)
        neg_count = sum(1 for word in negative_words if word in text)
        
        if neg_count > pos_count:
            return "Aggressive"
        elif pos_count > neg_count:
            return "Persuasive"
        else:
            return "Neutral"
    
    def analyze_call(self, transcript, scammer_id=None):
        """Comprehensive call analysis"""
        # Extract keywords
        keywords = self.extract_keywords(transcript)
        
        # Detect patterns
        patterns, pattern_scores = self.detect_scam_patterns(transcript)
        
        # Calculate risk
        risk_score = self.calculate_risk_score(transcript, patterns)
        risk_level = self.determine_risk_level(risk_score)
        
        # Sentiment
        sentiment = self.extract_sentiment(transcript)
        
        # Scammer match if ID provided
        scammer_match = None
        if scammer_id:
            scammer_match = self.get_scammer_info(scammer_id)
        
        analysis = {
            "keywords": keywords,
            "detected_patterns": patterns,
            "pattern_scores": pattern_scores,
            "risk_score": risk_score,
            "risk_level": risk_level,
            "sentiment": sentiment,
            "scammer_match": scammer_match,
            "confidence": min(0.95, risk_score / 100),
            "analysis_timestamp": datetime.now().isoformat()
        }
        
        return analysis
    
    def get_scammer_info(self, scammer_id):
        """Get scammer information"""
        for scammer in self.scammers:
            if scammer.get('id') == scammer_id:
                return scammer
        return None
    
    def get_all_scammers(self):
        """Get all scammers sorted by risk level"""
        risk_order = {"Critical": 0, "High": 1, "Medium": 2, "Low": 3}
        sorted_scammers = sorted(
            self.scammers,
            key=lambda x: risk_order.get(x.get('riskLevel', 'Low'), 4)
        )
        return sorted_scammers
    
    def generate_intelligence_report(self):
        """Generate intelligence report"""
        total_scammers = len(self.scammers)
        critical_count = sum(1 for s in self.scammers if s.get('riskLevel') == 'Critical')
        high_count = sum(1 for s in self.scammers if s.get('riskLevel') == 'High')
        
        total_reports = sum(s.get('reportCount', 0) for s in self.scammers)
        avg_success_rate = sum(s.get('successRate', 0) for s in self.scammers) / total_scammers if total_scammers > 0 else 0
        
        # Most common scam types
        scam_types = Counter(s.get('scamType', 'Unknown') for s in self.scammers)
        
        report = {
            "report_date": datetime.now().isoformat(),
            "total_scammers_tracked": total_scammers,
            "critical_threats": critical_count,
            "high_threats": high_count,
            "total_reports_filed": total_reports,
            "average_success_rate": round(avg_success_rate, 2),
            "common_scam_types": dict(scam_types.most_common(5)),
            "summary": f"{total_scammers} active scammers tracked with {critical_count} critical threats"
        }
        
        return report
