import '../models/scammer.dart';

class MockScammersData {
  static List<Scammer> getScammers() {
    return [
      Scammer(
        id: 'scammer_01',
        phoneNumber: '+91-98765-43210',
        name: 'Rajesh Kumar (Fake)',
        riskLevel: 'Critical',
        callCount: 23,
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
        scamTypes: ['Bank Fraud', 'Phishing', 'Account Compromise'],
        region: 'Unknown (Likely Delhi/NCR)',
        honeypotActive: true,
      ),
      Scammer(
        id: 'scammer_02',
        phoneNumber: '+91-87654-32109',
        name: 'Priya Singh (Fake)',
        riskLevel: 'High',
        callCount: 15,
        lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
        scamTypes: ['E-commerce Phishing', 'Account Theft'],
        region: 'Unknown (Likely Mumbai)',
        honeypotActive: true,
      ),
      Scammer(
        id: 'scammer_03',
        phoneNumber: '+91-76543-21098',
        name: 'Mahesh Patel (Fake)',
        riskLevel: 'Critical',
        callCount: 34,
        lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
        scamTypes: ['Lottery Fraud', 'Prize Scam', 'Financial Exploitation'],
        region: 'Unknown (Likely Bangalore)',
        honeypotActive: false,
      ),
      Scammer(
        id: 'scammer_04',
        phoneNumber: '+91-65432-10987',
        name: 'Anil Sharma (Fake)',
        riskLevel: 'High',
        callCount: 12,
        lastSeen: DateTime.now().subtract(const Duration(hours: 12)),
        scamTypes: ['OTP Theft', 'Identity Theft'],
        region: 'Unknown (Likely Kolkata)',
        honeypotActive: false,
      ),
      Scammer(
        id: 'scammer_05',
        phoneNumber: '+91-54321-09876',
        name: 'Neha Roy (Fake)',
        riskLevel: 'Medium',
        callCount: 8,
        lastSeen: DateTime.now().subtract(const Duration(hours: 24)),
        scamTypes: ['Delivery Fraud', 'Package Impersonation'],
        region: 'Unknown (Likely Chennai)',
        honeypotActive: false,
      ),
      Scammer(
        id: 'scammer_06',
        phoneNumber: '+91-43210-98765',
        name: 'Suresh Desai (Fake)',
        riskLevel: 'Critical',
        callCount: 47,
        lastSeen: DateTime.now().subtract(const Duration(days: 1)),
        scamTypes: [
          'Government Impersonation',
          'Tax Fraud',
          'Legal Threat Scam'
        ],
        region: 'Unknown (Likely Hyderabad)',
        honeypotActive: false,
      ),
      Scammer(
        id: 'scammer_07',
        phoneNumber: '+91-32109-87654',
        name: 'Pooja Mishra (Fake)',
        riskLevel: 'Medium',
        callCount: 6,
        lastSeen: DateTime.now().subtract(const Duration(days: 2)),
        scamTypes: ['Insurance Scam', 'Health Insurance Fraud'],
        region: 'Unknown (Likely Pune)',
        honeypotActive: false,
      ),
    ];
  }

  static List<Scammer> getCriticalScammers() {
    return getScammers()
        .where((scammer) => scammer.riskLevel == 'Critical')
        .toList();
  }

  static List<Scammer> getActiveHoneypots() {
    return getScammers()
        .where((scammer) => scammer.honeypotActive)
        .toList();
  }

  static Scammer getScammerById(String id) {
    try {
      return getScammers().firstWhere((scammer) => scammer.id == id);
    } catch (e) {
      return getScammers().first;
    }
  }

  static int getTotalCallsFromScammers() {
    return getScammers().fold(0, (sum, scammer) => sum + scammer.callCount);
  }
}
