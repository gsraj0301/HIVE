// Model for Spam Call
class SpamCall {
  final String id;
  final String scammerId;
  final String phoneNumber;
  final String scammerName;
  final String transcript; // The conversation text
  final List<String> keywords; // Extracted keywords (UPI, bank names, URLs, etc.)
  final int duration; // in seconds
  final DateTime timestamp;
  final String riskLevel; // Low, Medium, High, Critical
  final bool honeypotEngaged; // Whether honeypot was active
  final List<CallMessage> messages; // Chat messages

  SpamCall({
    required this.id,
    required this.scammerId,
    required this.phoneNumber,
    required this.scammerName,
    required this.transcript,
    required this.keywords,
    required this.duration,
    required this.timestamp,
    required this.riskLevel,
    required this.honeypotEngaged,
    required this.messages,
  });

  factory SpamCall.fromJson(Map<String, dynamic> json) {
    return SpamCall(
      id: json['id'] ?? '',
      scammerId: json['scammer_id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      scammerName: json['scammer_name'] ?? '',
      transcript: json['transcript'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      duration: json['duration'] ?? 0,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      riskLevel: json['risk_level'] ?? 'Medium',
      honeypotEngaged: json['honeypot_engaged'] ?? false,
      messages: (json['messages'] as List?)?.map((m) => CallMessage.fromJson(m)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scammer_id': scammerId,
      'phone_number': phoneNumber,
      'scammer_name': scammerName,
      'transcript': transcript,
      'keywords': keywords,
      'duration': duration,
      'timestamp': timestamp.toIso8601String(),
      'risk_level': riskLevel,
      'honeypot_engaged': honeypotEngaged,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }
}

// Model for individual messages in a call
class CallMessage {
  final String sender; // 'user', 'scammer', 'ai'
  final String message;
  final DateTime timestamp;
  final List<String> highlightedKeywords; // Keywords in this message

  CallMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.highlightedKeywords,
  });

  factory CallMessage.fromJson(Map<String, dynamic> json) {
    return CallMessage(
      sender: json['sender'] ?? 'user',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      highlightedKeywords: List<String>.from(json['highlighted_keywords'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'highlighted_keywords': highlightedKeywords,
    };
  }
}
