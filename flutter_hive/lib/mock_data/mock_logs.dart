import '../models/attack_log.dart';

class MockLogsData {
  static List<AttackLog> getLogs() {
    return [
      AttackLog(
        id: 'log_001',
        attackType: 'Phishing',
        description: 'ICICI Bank impersonation scam call',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        severity: 'Critical',
        sourceIP: '192.168.1.105',
        duration: 240,
        keywords: ['r.kumar@icici', '50000', 'ICICI Bank', 'UPI ID'],
      ),
      AttackLog(
        id: 'log_002',
        attackType: 'Phishing',
        description: 'Amazon account suspension fake alert',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        severity: 'High',
        sourceIP: '10.0.0.45',
        duration: 180,
        keywords: ['http://amaz0n-verify.xyz', '25000', 'Amazon'],
      ),
      AttackLog(
        id: 'log_003',
        attackType: 'Financial Fraud',
        description: 'Lottery scam with false prize claims',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        severity: 'Critical',
        sourceIP: '172.16.0.20',
        duration: 300,
        keywords: [
          'Rs 5 lakhs',
          'processing fee',
          '1234567890@hdfc',
          'lottery'
        ],
      ),
      AttackLog(
        id: 'log_004',
        attackType: 'Identity Theft',
        description: 'OTP verification attempt',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        severity: 'High',
        sourceIP: '192.168.0.50',
        duration: 210,
        keywords: ['OTP', 'verification', 'bank'],
      ),
      AttackLog(
        id: 'log_005',
        attackType: 'DDoS Attack',
        description: 'Simulated DDoS attempt detected on network',
        timestamp: DateTime.now().subtract(const Duration(hours: 24)),
        severity: 'Medium',
        sourceIP: '203.0.113.42',
        duration: 120,
        keywords: ['DDoS', 'network', 'traffic spike'],
      ),
      AttackLog(
        id: 'log_006',
        attackType: 'Malware',
        description: 'Suspicious link sent via SMS',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        severity: 'High',
        sourceIP: '198.51.100.89',
        duration: 0,
        keywords: [
          'malware',
          'suspicious link',
          'http://suspicious-site.com'
        ],
      ),
      AttackLog(
        id: 'log_007',
        attackType: 'Phishing',
        description: 'Fake delivery notification SMS',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        severity: 'Medium',
        sourceIP: '192.0.2.1',
        duration: 0,
        keywords: ['delivery', 'package', 'confirm', 'link'],
      ),
      AttackLog(
        id: 'log_008',
        attackType: 'SMS Spoofing',
        description: 'SMS impersonating government agency',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        severity: 'Critical',
        sourceIP: '203.0.113.100',
        duration: 0,
        keywords: ['government', 'tax', 'action', 'respond'],
      ),
    ];
  }

  static List<AttackLog> getLogsByType(String type) {
    return getLogs().where((log) => log.attackType == type).toList();
  }

  static List<AttackLog> getLogsBySeverity(String severity) {
    return getLogs().where((log) => log.severity == severity).toList();
  }

  static List<String> getUniquAttackTypes() {
    final types = <String>{};
    for (var log in getLogs()) {
      types.add(log.attackType);
    }
    return types.toList();
  }

  static Map<String, int> getAttackTypeCount() {
    final count = <String, int>{};
    for (var log in getLogs()) {
      count[log.attackType] = (count[log.attackType] ?? 0) + 1;
    }
    return count;
  }

  static int getTotalAttacksToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return getLogs().where((log) => log.timestamp.isAfter(today)).length;
  }
}
