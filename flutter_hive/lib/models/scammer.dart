// Model for Scammer/Spammer Information
class Scammer {
  final String id;
  final String phoneNumber;
  final String name; // Scammer name/alias if known
  final String riskLevel; // Low, Medium, High, Critical
  final int callCount;
  final DateTime lastSeen;
  final List<String> scamTypes; // Types of scams from this number
  final String region; // Geographic region
  final bool honeypotActive; // Is honeypot currently active with this scammer

  Scammer({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.riskLevel,
    required this.callCount,
    required this.lastSeen,
    required this.scamTypes,
    required this.region,
    required this.honeypotActive,
  });

  factory Scammer.fromJson(Map<String, dynamic> json) {
    return Scammer(
      id: json['id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      name: json['name'] ?? 'Unknown',
      riskLevel: json['risk_level'] ?? 'Medium',
      callCount: json['call_count'] ?? 0,
      lastSeen: DateTime.parse(json['last_seen'] ?? DateTime.now().toIso8601String()),
      scamTypes: List<String>.from(json['scam_types'] ?? []),
      region: json['region'] ?? 'Unknown',
      honeypotActive: json['honeypot_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'name': name,
      'risk_level': riskLevel,
      'call_count': callCount,
      'last_seen': lastSeen.toIso8601String(),
      'scam_types': scamTypes,
      'region': region,
      'honeypot_active': honeypotActive,
    };
  }
}
