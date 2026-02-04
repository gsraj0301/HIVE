// Model for Alerts
class Alert {
  final String id;
  final String title;
  final String message;
  final String severity; // Low, Medium, High, Critical
  final DateTime timestamp;
  final String type; // Scam, Phishing, DDoS, Malware, etc.
  final bool isRead;
  final String? sourcePhoneNumber;
  final List<String>? suggestedActions;

  Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    required this.type,
    required this.isRead,
    this.sourcePhoneNumber,
    this.suggestedActions,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      severity: json['severity'] ?? 'Medium',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      type: json['type'] ?? 'Unknown',
      isRead: json['is_read'] ?? false,
      sourcePhoneNumber: json['source_phone_number'],
      suggestedActions: json['suggested_actions'] != null
          ? List<String>.from(json['suggested_actions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'severity': severity,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'is_read': isRead,
      'source_phone_number': sourcePhoneNumber,
      'suggested_actions': suggestedActions,
    };
  }
}
