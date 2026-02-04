import '../models/alert.dart';

class MockAlertsData {
  static List<Alert> getAlerts() {
    return [
      Alert(
        id: 'alert_001',
        title: 'Critical: Scam Attempt Detected',
        message:
            'A high-risk scam call from +91-98765-43210 (ICICI Bank Impersonation) has been intercepted. Honeypot engaged.',
        severity: 'Critical',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: 'Phishing/Bank Fraud',
        isRead: false,
        sourcePhoneNumber: '+91-98765-43210',
        suggestedActions: [
          'Block this number',
          'Report to Cyber Crime',
          'View extracted keywords'
        ],
      ),
      Alert(
        id: 'alert_002',
        title: 'High: Amazon Phishing Attack',
        message:
            'Phishing attempt detected. Scammer sent malicious link: http://amaz0n-verify.xyz',
        severity: 'High',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: 'Phishing',
        isRead: false,
        sourcePhoneNumber: '+91-87654-32109',
        suggestedActions: [
          'Report link to Amazon',
          'Block number',
          'View conversation'
        ],
      ),
      Alert(
        id: 'alert_003',
        title: 'Critical: Lottery Scam',
        message:
            'Classic lottery scam detected. False claims of Rs 5 lakhs prize. Requesting processing fee payment.',
        severity: 'Critical',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: 'Financial Fraud',
        isRead: true,
        sourcePhoneNumber: '+91-76543-21098',
        suggestedActions: [
          'Block number immediately',
          'Report to police',
          'Share with contacts'
        ],
      ),
      Alert(
        id: 'alert_004',
        title: 'Medium: Suspicious Activity',
        message:
            'Multiple calls from unregistered numbers detected in the last hour.',
        severity: 'Medium',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        type: 'Suspicious Pattern',
        isRead: true,
        sourcePhoneNumber: null,
        suggestedActions: [
          'Enable call filtering',
          'Review call logs'
        ],
      ),
      Alert(
        id: 'alert_005',
        title: 'High: OTP Theft Attempt',
        message:
            'Scammer asked for OTP during the call. This is a common OTP theft tactic.',
        severity: 'High',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        type: 'Identity Theft',
        isRead: true,
        sourcePhoneNumber: '+91-65432-10987',
        suggestedActions: [
          'Enable two-factor authentication',
          'Change passwords'
        ],
      ),
    ];
  }

  static List<Alert> getCriticalAlerts() {
    return getAlerts().where((alert) => alert.severity == 'Critical').toList();
  }

  static List<Alert> getUnreadAlerts() {
    return getAlerts().where((alert) => !alert.isRead).toList();
  }
}
