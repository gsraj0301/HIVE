import 'package:flutter/material.dart';
import '../models/call.dart';
import '../models/scammer.dart';
import '../mock_data/mock_calls.dart';
import '../mock_data/mock_scammers.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/keyword_highlight.dart';
import '../widgets/severity_badge.dart';

class CallSimulationScreen extends StatefulWidget {
  const CallSimulationScreen({super.key});

  @override
  State<CallSimulationScreen> createState() => _CallSimulationScreenState();
}

class _CallSimulationScreenState extends State<CallSimulationScreen> {
  SpamCall? currentCall;
  Scammer? currentScammer;
  bool isCallActive = false;
  int messageIndex = 0;

  void startCall(SpamCall call) {
    setState(() {
      currentCall = call;
      isCallActive = true;
      messageIndex = 0;
      currentScammer = MockScammersData.getScammerById(call.scammerId);
    });
  }

  void endCall() {
    setState(() {
      isCallActive = false;
      currentCall = null;
      messageIndex = 0;
    });
  }

  void nextMessage() {
    if (currentCall != null && messageIndex < currentCall!.messages.length - 1) {
      setState(() {
        messageIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Active Call',
        showNotificationBell: false,
      ),
      body: isCallActive && currentCall != null
          ? buildCallInterface()
          : buildCallList(),
    );
  }

  Widget buildCallInterface() {
    final call = currentCall!;
    return Container(
      decoration: AppTheme.backgroundGradient,
      child: Column(
        children: [
          // Call Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.cardBackground,
                  AppTheme.surfaceDark,
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryPurple,
                        AppTheme.accentBlue,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryPurple.withValues(alpha: 0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.call_received,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  call.scammerName,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  call.phoneNumber,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                SeverityBadge(severity: call.riskLevel),
              ],
            ),
          ),
          // Conversation
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (int i = 0; i <= messageIndex; i++)
                  buildMessageBubble(call.messages[i], i),
              ],
            ),
          ),
          // Keywords Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.borderColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Extracted Keywords:',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: call.keywords
                      .map((keyword) => KeywordHighlight(
                            keyword: keyword,
                            isHighlighted: true,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          // Controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: messageIndex < currentCall!.messages.length - 1
                        ? nextMessage
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentBlue,
                      disabledBackgroundColor:
                          AppTheme.accentBlue.withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next Message'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: endCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.criticalRed,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.call_end),
                  label: const Text('End Call'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageBubble(CallMessage message, int index) {
    final isUser = message.sender == 'user';
    final isAI = message.sender == 'ai';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isAI
                ? AppTheme.accentBlue.withValues(alpha: 0.2)
                : (isUser ? AppTheme.primaryPurple : AppTheme.surfaceDark),
            border: Border.all(
              color: isAI
                  ? AppTheme.accentBlue
                  : (isUser ? AppTheme.primaryPurple : AppTheme.borderColor),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAI)
                Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.smart_toy_outlined,
                        size: 14,
                        color: AppTheme.accentBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AI Honeypot',
                        style: TextStyle(
                          color: AppTheme.accentBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                message.message,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                ),
              ),
              if (message.highlightedKeywords.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: message.highlightedKeywords
                      .map((keyword) => KeywordHighlight(
                            keyword: keyword,
                            isHighlighted: true,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCallList() {
    final calls = MockCallsData.getSpamCalls();

    return Container(
      decoration: AppTheme.backgroundGradient,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: calls.length,
        itemBuilder: (context, index) {
          final call = calls[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => startCall(call),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassmorphicCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                call.scammerName,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                call.phoneNumber,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SeverityBadge(severity: call.riskLevel, fontSize: 11),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      call.transcript,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Duration: ${call.duration}s',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        if (call.honeypotEngaged)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentBlue.withValues(alpha: 0.2),
                              border: Border.all(color: AppTheme.accentBlue),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.smart_toy_outlined,
                                  size: 12,
                                  color: AppTheme.accentBlue,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Honeypot Active',
                                  style: TextStyle(
                                    color: AppTheme.accentBlue,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
