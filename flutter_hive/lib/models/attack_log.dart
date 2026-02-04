// Model for Attack Logs
class AttackLog {
  final String id;
  final String attackType; // SSH, SMS, Malware, DDoS, Phishing, etc.
  final String description;
  final DateTime timestamp;
  final String severity; // Low, Medium, High, Critical
  final String sourceIP;
  final int duration; // in seconds
  final List<String> keywords; // Extracted keywords like UPI, phone, bank names

  AttackLog({
    required this.id,
    required this.attackType,
    required this.description,
    required this.timestamp,
    required this.severity,
    required this.sourceIP,
    required this.duration,
    required this.keywords,
  });

  factory AttackLog.fromJson(Map<String, dynamic> json) {
    return AttackLog(
      id: json['id'] ?? '',
      attackType: json['attack_type'] ?? '',
      description: json['description'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      severity: json['severity'] ?? 'Medium',
      sourceIP: json['source_ip'] ?? '',
      duration: json['duration'] ?? 0,
      keywords: List<String>.from(json['keywords'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attack_type': attackType,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
      'source_ip': sourceIP,
      'duration': duration,
      'keywords': keywords,
    };
  }
}
