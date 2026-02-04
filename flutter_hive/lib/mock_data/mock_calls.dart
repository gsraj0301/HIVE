import '../models/call.dart';

// Mock spam call data with realistic scammer conversations
class MockCallsData {
  static List<SpamCall> getSpamCalls() {
    return [
      SpamCall(
        id: 'call_001',
        scammerId: 'scammer_01',
        phoneNumber: '+91-98765-43210',
        scammerName: 'Rajesh Kumar (Fake)',
        transcript:
            'Scammer: Hello sir, this is Rajesh from ICICI Bank... User: Hi... Scammer: Sir, we detected suspicious activity on your account. Your account has been compromised. Can you please verify your UPI ID? User: Which UPI ID? Scammer: Your registered UPI ID starting with r.kumar@icici. We need to verify it for security. User: I will not share that... Scammer: Sir this is urgent, a transaction of 50,000 is pending...',
        keywords: [
          'r.kumar@icici',
          '50000',
          'ICICI Bank',
          'UPI ID',
          'suspicious activity'
        ],
        duration: 240,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        riskLevel: 'Critical',
        honeypotEngaged: true,
        messages: [
          CallMessage(
            sender: 'scammer',
            message: 'Hello sir, this is Rajesh from ICICI Bank',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            highlightedKeywords: ['ICICI Bank'],
          ),
          CallMessage(
            sender: 'user',
            message: 'Hi',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
            highlightedKeywords: [],
          ),
          CallMessage(
            sender: 'scammer',
            message:
                'Sir, we detected suspicious activity on your account. Your account has been compromised.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
            highlightedKeywords: ['suspicious activity'],
          ),
          CallMessage(
            sender: 'scammer',
            message: 'Can you please verify your UPI ID?',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
            highlightedKeywords: ['UPI ID'],
          ),
          CallMessage(
            sender: 'user',
            message: 'Which UPI ID?',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)),
            highlightedKeywords: [],
          ),
          CallMessage(
            sender: 'scammer',
            message: 'Your registered UPI ID starting with r.kumar@icici',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 25)),
            highlightedKeywords: ['r.kumar@icici', 'UPI ID'],
          ),
          CallMessage(
            sender: 'ai',
            message: 'I will verify the details with the bank. One moment please.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
            highlightedKeywords: [],
          ),
        ],
      ),
      SpamCall(
        id: 'call_002',
        scammerId: 'scammer_02',
        phoneNumber: '+91-87654-32109',
        scammerName: 'Priya Singh (Fake)',
        transcript:
            'Scammer: Hello, your Amazon account is suspended. User: What? Scammer: Yes, please click on this link immediately: http://amaz0n-verify.xyz to reactivate. There is a pending order of Rs 25,000 that needs verification.',
        keywords: [
          'Amazon',
          'suspended',
          'http://amaz0n-verify.xyz',
          '25000',
          'verification'
        ],
        duration: 180,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        riskLevel: 'High',
        honeypotEngaged: true,
        messages: [
          CallMessage(
            sender: 'scammer',
            message: 'Hello, your Amazon account is suspended',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            highlightedKeywords: ['Amazon', 'suspended'],
          ),
          CallMessage(
            sender: 'user',
            message: 'What? I did not do anything',
            timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 2)),
            highlightedKeywords: [],
          ),
          CallMessage(
            sender: 'scammer',
            message:
                'Click on this link immediately: http://amaz0n-verify.xyz to reactivate',
            timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 5)),
            highlightedKeywords: ['http://amaz0n-verify.xyz'],
          ),
          CallMessage(
            sender: 'scammer',
            message: 'There is a pending order of Rs 25,000 that needs verification',
            timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 10)),
            highlightedKeywords: ['25000', 'verification'],
          ),
          CallMessage(
            sender: 'ai',
            message:
                'I will check the Amazon account. Thank you for waiting. I am verifying the transaction...',
            timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 15)),
            highlightedKeywords: [],
          ),
        ],
      ),
      SpamCall(
        id: 'call_003',
        scammerId: 'scammer_03',
        phoneNumber: '+91-76543-21098',
        scammerName: 'Mahesh Patel (Fake)',
        transcript:
            'Scammer: Sir, you have won a lottery prize of Rs 5 lakhs from Ministry of Finance. User: Really? Scammer: Yes, but first you need to pay Rs 5000 as processing fee to our account 1234567890@hdfc. Then we will transfer your prize money.',
        keywords: [
          'lottery',
          'Rs 5 lakhs',
          'processing fee',
          '1234567890@hdfc',
          'Ministry of Finance'
        ],
        duration: 300,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        riskLevel: 'Critical',
        honeypotEngaged: false,
        messages: [
          CallMessage(
            sender: 'scammer',
            message:
                'Sir, you have won a lottery prize of Rs 5 lakhs from Ministry of Finance',
            timestamp: DateTime.now().subtract(const Duration(hours: 8)),
            highlightedKeywords: ['lottery', 'Rs 5 lakhs', 'Ministry of Finance'],
          ),
          CallMessage(
            sender: 'user',
            message: 'Really? That sounds amazing!',
            timestamp: DateTime.now().subtract(const Duration(hours: 8, minutes: 3)),
            highlightedKeywords: [],
          ),
          CallMessage(
            sender: 'scammer',
            message:
                'Yes, but first you need to pay Rs 5000 as processing fee to account 1234567890@hdfc',
            timestamp: DateTime.now().subtract(const Duration(hours: 8, minutes: 6)),
            highlightedKeywords: ['processing fee', '1234567890@hdfc', 'Rs 5000'],
          ),
        ],
      ),
    ];
  }

  static SpamCall getCallById(String id) {
    try {
      return getSpamCalls().firstWhere((call) => call.id == id);
    } catch (e) {
      return getSpamCalls().first;
    }
  }
}
