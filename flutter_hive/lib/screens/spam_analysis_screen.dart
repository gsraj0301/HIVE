import 'package:flutter/material.dart';
import 'package:flutter_hive/theme/app_theme.dart';
import 'package:flutter_hive/services/api_service.dart';

class SpamAnalysisScreen extends StatefulWidget {
  const SpamAnalysisScreen({super.key});

  @override
  State<SpamAnalysisScreen> createState() => _SpamAnalysisScreenState();
}

class _SpamAnalysisScreenState extends State<SpamAnalysisScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  String _messageType = 'EMAIL';
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;
  String? _error;
  bool _isUsingFallback = false;

  static Map<String, dynamic> _getDefaultAnalysis() {
    return {
      'analysis': {
        'keywords': ['suspicious', 'verify', 'urgent', 'click', 'account'],
        'spam_probability': 0.89,
        'risk_level': 'High',
        'type': 'Phishing',
        'suggested_action': 'Do not click any links. Report to relevant authorities.',
        'confidence': 0.92,
      }
    };
  }

  @override
  void dispose() {
    _messageController.dispose();
    _senderController.dispose();
    super.dispose();
  }

  Future<void> _analyzeMessage() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message to analyze')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _error = null;
      _analysisResult = null;
      _isUsingFallback = false;
    });

    try {
      final result = await ApiService.analyzeSpamMessage(
        content: _messageController.text,
        messageType: _messageType,
        sender: _senderController.text.isNotEmpty ? _senderController.text : null,
      );

      setState(() {
        _analysisResult = result;
        _isUsingFallback = false;
      });
    } catch (e) {
      // Use fallback data on error
      setState(() {
        _analysisResult = _getDefaultAnalysis();
        _error = 'Using mock analysis (API unavailable)';
        _isUsingFallback = true;
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Analyze Spam Message'),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Type Selector
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentCyan.withOpacity(0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: _messageType,
                isExpanded: true,
                dropdownColor: AppTheme.cardColor,
                style: TextStyle(color: AppTheme.textColor),
                underline: const SizedBox(),
                items: ['EMAIL', 'SMS'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _messageType = value ?? 'EMAIL';
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Sender Input
            TextField(
              controller: _senderController,
              style: TextStyle(color: AppTheme.textColor),
              decoration: InputDecoration(
                hintText: 'Sender Email/Number (optional)',
                hintStyle: TextStyle(color: AppTheme.textColor.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.accentCyan, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.accentCyan, width: 1),
                ),
                filled: true,
                fillColor: AppTheme.cardColor,
              ),
            ),
            const SizedBox(height: 16),

            // Message Input
            TextField(
              controller: _messageController,
              style: TextStyle(color: AppTheme.textColor),
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Paste the suspicious message here...',
                hintStyle: TextStyle(color: AppTheme.textColor.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.accentCyan, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.accentCyan, width: 1),
                ),
                filled: true,
                fillColor: AppTheme.cardColor,
              ),
            ),
            const SizedBox(height: 24),

            // Analyze Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentBlue,
                  disabledBackgroundColor: AppTheme.accentBlue.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isAnalyzing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.analytics),
                label: Text(
                  _isAnalyzing ? 'Analyzing...' : 'Analyze Message',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Error/Fallback Message
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isUsingFallback 
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  border: Border.all(
                    color: _isUsingFallback ? Colors.orange : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isUsingFallback 
                          ? Icons.info_outline 
                          : Icons.error_outline,
                      color: _isUsingFallback ? Colors.orange : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error ?? '',
                        style: TextStyle(
                          color: _isUsingFallback 
                              ? Colors.orange 
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Analysis Results
            if (_analysisResult != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentCyan.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Analysis Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildResultRow(
                      'Spam Score',
                      '${_analysisResult!['analysis']['spamScore']}/100',
                      _analysisResult!['analysis']['spamScore'] >= 40
                          ? Colors.red
                          : Colors.green,
                    ),
                    _buildResultRow(
                      'Threat Type',
                      _analysisResult!['analysis']['type'],
                      AppTheme.accentCyan,
                    ),
                    _buildResultRow(
                      'Confidence',
                      '${_analysisResult!['analysis']['confidence']}%',
                      AppTheme.accentBlue,
                    ),
                    const Divider(color: AppTheme.accentCyan),
                    const SizedBox(height: 12),
                    const Text(
                      'Detected Keywords:',
                      style: TextStyle(
                        color: AppTheme.accentCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: (_analysisResult!['analysis']['keywords'] as List?)
                              ?.map<Widget>((kw) {
                            return Chip(
                              label: Text(kw),
                              backgroundColor: AppTheme.accentCyan.withOpacity(0.2),
                              labelStyle: const TextStyle(
                                color: AppTheme.accentCyan,
                                fontSize: 12,
                              ),
                            );
                          }).toList() ??
                          [],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Suggested Auto-Reply:',
                      style: TextStyle(
                        color: AppTheme.accentCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.darkBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.accentBlue.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _analysisResult!['suggestedReply'],
                        style: const TextStyle(
                          color: AppTheme.textColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Reply queued: ${_analysisResult!['suggestedReply']}',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentBlue,
                        ),
                        child: const Text('Use Suggested Reply'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppTheme.textColor),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
