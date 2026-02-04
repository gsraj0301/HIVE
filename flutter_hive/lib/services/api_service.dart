import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  
  // For Android emulator: http://10.0.2.2:5000/api
  // For iOS simulator: http://localhost:5000/api
  // For production: https://your-deployed-backend.com/api
  
  static const Duration timeout = Duration(seconds: 30);

  // REAL DATA ANALYSIS ENDPOINTS

  /// Analyze call transcript for scam indicators
  static Future<Map<String, dynamic>> analyzeCall(
    String transcript, {
    String? scammerId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze-call'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'transcript': transcript,
          'scammer_id': scammerId,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['analysis'];
      } else {
        throw Exception('Failed to analyze call');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Extract keywords from text using real NLP
  static Future<List<String>> extractKeywords(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/extract-keywords'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return List<String>.from(jsonDecode(response.body)['keywords']);
      } else {
        throw Exception('Failed to extract keywords');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Detect scam patterns in transcript
  static Future<Map<String, dynamic>> detectPatterns(String transcript) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/detect-patterns'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'transcript': transcript}),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return {
          'patterns': json['patterns'],
          'pattern_scores': json['pattern_scores'],
        };
      } else {
        throw Exception('Failed to detect patterns');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Calculate risk score and level
  static Future<Map<String, dynamic>> calculateRisk(String transcript) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/calculate-risk'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'transcript': transcript}),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to calculate risk');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get all known scammers
  static Future<List<Map<String, dynamic>>> getScammers() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/scammers')).timeout(timeout);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            jsonDecode(response.body)['scammers']);
      } else {
        throw Exception('Failed to get scammers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get scammer by ID
  static Future<Map<String, dynamic>> getScammerById(String scammerId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/scammers/$scammerId'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['scammer'];
      } else {
        throw Exception('Scammer not found');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get intelligence report with analytics
  static Future<Map<String, dynamic>> getIntelligenceReport() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/intelligence-report'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['report'];
      } else {
        throw Exception('Failed to get report');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get all scam patterns
  static Future<List<Map<String, dynamic>>> getScamPatterns() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/scam-patterns'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            jsonDecode(response.body)['patterns']);
      } else {
        throw Exception('Failed to get patterns');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get active alerts
  static Future<List<Map<String, dynamic>>> getAlerts() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/alerts')).timeout(timeout);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            jsonDecode(response.body)['alerts']);
      } else {
        throw Exception('Failed to get alerts');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // LEGACY ENDPOINTS (KEPT FOR COMPATIBILITY)

  static Future<Map<String, dynamic>> analyzeSpamMessage({
    required String content,
    required String messageType,
    String? subject,
    String? sender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/spam-detection/analyze-message'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': content,
          'messageType': messageType,
          'subject': subject ?? '',
          'sender': sender ?? 'unknown',
        }),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to analyze message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error analyzing message: $e');
    }
  }

  static Future<Map<String, dynamic>> getSpamMessages({
    int skip = 0,
    int limit = 20,
    String? type,
  }) async {
    try {
      String url = '$baseUrl/spam-detection/messages?skip=$skip&limit=$limit';
      if (type != null) url += '&type=$type';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }

  static Future<Map<String, dynamic>> getSpamMessage(String messageId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/spam-detection/messages/$messageId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching message: $e');
    }
  }

  static Future<Map<String, dynamic>> sendAutoReply({
    required String messageId,
    required String reply,
    String stage = 'initial',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/spam-detection/auto-reply'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messageId': messageId,
          'reply': reply,
          'stage': stage,
        }),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send reply: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending reply: $e');
    }
  }

  static Future<Map<String, dynamic>> recordFollowUp({
    required String messageId,
    required String followUp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/spam-detection/auto-reply/$messageId/follow-up'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'followUp': followUp,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to record follow-up: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error recording follow-up: $e');
    }
  }

  static Future<Map<String, dynamic>> simulateCall({
    String scamType = 'banking',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/spam-detection/simulate-call'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'scamType': scamType,
        }),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to simulate call: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error simulating call: $e');
    }
  }

  static Future<Map<String, dynamic>> recordCallInteraction({
    required String callId,
    required String userResponse,
    required int stageIndex,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/spam-detection/simulate-call/$callId/record'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userResponse': userResponse,
          'stageIndex': stageIndex,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to record interaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error recording interaction: $e');
    }
  }

  static Future<Map<String, dynamic>> getCallSimulations({
    int skip = 0,
    int limit = 20,
    String? scamType,
  }) async {
    try {
      String url = '$baseUrl/spam-detection/calls?skip=$skip&limit=$limit';
      if (scamType != null) url += '&scamType=$scamType';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch calls: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching calls: $e');
    }
  }

  static Future<Map<String, dynamic>> getIntelligenceReport({
    int days = 7,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/spam-detection/intelligence-report?days=$days'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching report: $e');
    }
  }

  static Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/spam-detection/stats'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stats: $e');
    }
  }
}
