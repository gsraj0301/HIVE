import 'package:flutter/material.dart';
import '../mock_data/mock_logs.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/severity_badge.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    var logs = MockLogsData.getLogs();

    // Filter logs
    if (selectedFilter != 'All') {
      logs = MockLogsData.getLogsByType(selectedFilter);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Attack Logs',
        showNotificationBell: false,
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: Column(
          children: [
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: ['All', ...MockLogsData.getUniquAttackTypes()].map((type) {
                  final isSelected = selectedFilter == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = type;
                        });
                      },
                      backgroundColor: AppTheme.surfaceDark,
                      selectedColor: AppTheme.primaryPurple,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w400,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : AppTheme.borderColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Logs List
            Expanded(
              child: logs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: AppTheme.accentBlue.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No logs found',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              showLogDetails(log);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: AppTheme.glassmorphicCard,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        log.attackType,
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SeverityBadge(severity: log.severity),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    log.description,
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Source IP',
                                              style: TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 10,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              log.sourceIP,
                                              style: const TextStyle(
                                                color: AppTheme.textPrimary,
                                                fontSize: 12,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Duration',
                                              style: TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 10,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${log.duration}s',
                                              style: const TextStyle(
                                                color: AppTheme.textPrimary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Time',
                                              style: TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 10,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              formatTime(log.timestamp),
                                              style: const TextStyle(
                                                color: AppTheme.textPrimary,
                                                fontSize: 12,
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
            ),
          ],
        ),
      ),
    );
  }

  void showLogDetails(dynamic log) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppTheme.borderColor),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  log.attackType,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            buildDetailRow('Description', log.description),
            buildDetailRow('Source IP', log.sourceIP),
            buildDetailRow('Severity', log.severity),
            buildDetailRow('Duration', '${log.duration}s'),
            buildDetailRow('Timestamp',
                log.timestamp.toIso8601String().split('T')[0]),
            const SizedBox(height: 16),
            const Text(
              'Extracted Keywords',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: log.keywords
                  .map((keyword) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withValues(alpha: 0.2),
                          border: Border.all(color: AppTheme.accentBlue),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          keyword,
                          style: const TextStyle(
                            color: AppTheme.accentBlue,
                            fontSize: 11,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
