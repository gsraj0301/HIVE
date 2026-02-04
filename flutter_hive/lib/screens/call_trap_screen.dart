import 'package:flutter/material.dart';
import 'package:flutter_hive/theme/app_theme.dart';
import 'package:flutter_hive/services/api_service.dart';

class CallTrapScreen extends StatefulWidget {
  const CallTrapScreen({Key? key}) : super(key: key);

  @override
  State<CallTrapScreen> createState() => _CallTrapScreenState();
}

class _CallTrapScreenState extends State<CallTrapScreen> {
  String _selectedScamType = 'banking';
  bool _isGenerating = false;
  List<dynamic> _conversation = [];
  String? _currentCallId;
  int _currentStage = 0;
  int _totalTimeWasted = 0;
  String? _error;

  Future<void> _generateCallSimulation() async {
    setState(() {
      _isGenerating = true;
      _error = null;
      _conversation = [];
      _currentStage = 0;
      _totalTimeWasted = 0;
    });

    try {
      final result = await ApiService.simulateCall(scamType: _selectedScamType);

      setState(() {
        _currentCallId = result['callId'];
        _conversation = result['conversation'] as List;
        _totalTimeWasted = result['estimatedDuration'] ?? 0;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _recordResponse() async {
    if (_currentCallId == null) return;

    try {
      await ApiService.recordCallInteraction(
        callId: _currentCallId!,
        userResponse: 'Response recorded',
        stageIndex: _currentStage,
      );

      if (_currentStage < _conversation.length - 1) {
        setState(() {
          _currentStage++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Call simulation complete! Time wasted: ${_totalTimeWasted ~/ 60} minutes',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Call Trap Simulation'),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scam Type Selector
            const Text(
              'Select Scam Type:',
              style: TextStyle(
                color: AppTheme.accentBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentCyan.withOpacity(0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: _selectedScamType,
                isExpanded: true,
                dropdownColor: AppTheme.cardColor,
                style: TextStyle(color: AppTheme.textColor),
                underline: const SizedBox(),
                items: ['banking', 'lottery', 'investment']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type[0].toUpperCase() + type.substring(1),
                          ),
                        ))
                    .toList(),
                onChanged: _isGenerating
                    ? null
                    : (value) {
                        setState(() {
                          _selectedScamType = value ?? 'banking';
                          _conversation = [];
                          _currentStage = 0;
                        });
                      },
              ),
            ),
            const SizedBox(height: 24),

            // Generate Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateCallSimulation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentBlue,
                  disabledBackgroundColor: AppTheme.accentBlue.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isGenerating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.phone),
                label: Text(
                  _isGenerating ? 'Generating...' : 'Generate Call Simulation',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Error Display
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16),

            // Conversation Display
            if (_conversation.isNotEmpty) ...[
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Call Conversation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentCyan.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Stage ${_currentStage + 1}/${_conversation.length}',
                            style: const TextStyle(
                              color: AppTheme.accentCyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_currentStage < _conversation.length) ...[
                      // Spammer's Message
                      Text(
                        'Scammer:',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _conversation[_currentStage]['spammerMessage'],
                          style: TextStyle(color: AppTheme.textColor),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Our Response
                      Text(
                        'Your Response:',
                        style: TextStyle(
                          color: Colors.green.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _conversation[_currentStage]['ourResponse'],
                          style: TextStyle(color: AppTheme.textColor),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Techniques Used
                      Wrap(
                        spacing: 8,
                        children:
                            (_conversation[_currentStage]['techniquesUsed'] as List?)
                                    ?.map<Widget>((technique) {
                                  return Chip(
                                    label: Text(technique),
                                    backgroundColor: Colors.orange.withOpacity(0.2),
                                    labelStyle: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 11,
                                    ),
                                  );
                                }).toList() ??
                                [],
                      ),
                      const SizedBox(height: 20),

                      // Next Stage Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _recordResponse,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.navigate_next),
                          label: Text(
                            _currentStage < _conversation.length - 1
                                ? 'Next Stage'
                                : 'Complete Call',
                          ),
                        ),
                      ),
                    ],

                    // Stats
                    const SizedBox(height: 24),
                    const Divider(color: AppTheme.accentCyan),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${_totalTimeWasted ~/ 60}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentBlue,
                              ),
                            ),
                            Text(
                              'Minutes Wasted',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${_conversation.length}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentCyan,
                              ),
                            ),
                            Text(
                              'Call Stages',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
