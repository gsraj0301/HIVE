import 'package:flutter/material.dart';
import '../mock_data/mock_logs.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/severity_badge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedPeriod = 'Today';

  @override
  Widget build(BuildContext context) {
    final logs = MockLogsData.getLogs();
    final totalAttacks = MockLogsData.getTotalAttacksToday();
    final attackCounts = MockLogsData.getAttackTypeCount();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        unreadCount: 3,
        onNotificationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification feature coming soon!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Chatbot Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.borderColor.withOpacity(0.3),
                  ),
                ),
                child: TextField(
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Ask anything you need...',
                    hintStyle: const TextStyle(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: AppTheme.accentBlue),
                    suffixIcon: const Icon(Icons.smart_toy_outlined,
                        color: AppTheme.accentBlue),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Attack Activity Section
              const Text(
                'Attack Activity',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Period Toggle Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Today', 'Week', 'Month'].map((period) {
                    final isSelected = selectedPeriod == period;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPeriod = period;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.primaryPurple,
                                      AppTheme.accentBlue,
                                    ],
                                  )
                                : null,
                            color: isSelected ? null : AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : AppTheme.borderColor,
                            ),
                          ),
                          child: Text(
                            period,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              // Attack Chart Placeholder
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassmorphicCard,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildChartBar(35),
                        buildChartBar(50),
                        buildChartBar(45),
                        buildChartBar(65),
                        buildChartBar(55),
                        buildChartBar(70),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Mon', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                        Text('Tue', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                        Text('Wed', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                        Text('Thu', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                        Text('Fri', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                        Text('Sat', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Total Attacks Today
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.glassmorphicCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Attacks Today',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          totalAttacks.toString(),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.criticalRed.withOpacity(0.2),
                            border: Border.all(color: AppTheme.criticalRed),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 16,
                                color: AppTheme.criticalRed,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '+18%',
                                style: TextStyle(
                                  color: AppTheme.criticalRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Attacks increased from yesterday',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Attack Types
              const Text(
                'Attack Types',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: attackCounts.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      border: Border.all(color: AppTheme.borderColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getIconForAttackType(entry.key),
                          size: 16,
                          color: AppTheme.accentBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${entry.key} (${entry.value})',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Recent Logs
              const Text(
                'Recent Attacks',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...logs.take(3).map((log) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: AppTheme.glassmorphicCard,
                    child: Row(
                      children: [
                        Icon(
                          getIconForAttackType(log.attackType),
                          color: AppTheme.accentBlue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.attackType,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                log.description,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SeverityBadge(severity: log.severity, fontSize: 10),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChartBar(double height) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppTheme.accentBlue,
            AppTheme.accentCyan,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withOpacity(0.5),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }

  IconData getIconForAttackType(String type) {
    switch (type.toLowerCase()) {
      case 'phishing':
        return Icons.email_outlined;
      case 'ddos':
        return Icons.cloud_off_outlined;
      case 'malware':
        return Icons.bug_report_outlined;
      case 'financial fraud':
        return Icons.money_off_outlined;
      case 'identity theft':
        return Icons.person_off_outlined;
      case 'sms spoofing':
        return Icons.sms_failed_outlined;
      default:
        return Icons.shield_outlined;
    }
  }
}
