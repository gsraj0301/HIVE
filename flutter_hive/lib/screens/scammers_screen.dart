import 'package:flutter/material.dart';
import '../mock_data/mock_scammers.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/severity_badge.dart';

class ScammersScreen extends StatefulWidget {
  const ScammersScreen({super.key});

  @override
  State<ScammersScreen> createState() => _ScammersScreenState();
}

class _ScammersScreenState extends State<ScammersScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    var scammers = MockScammersData.getScammers();

    // Filter scammers
    if (selectedFilter == 'Critical') {
      scammers = MockScammersData.getCriticalScammers();
    } else if (selectedFilter == 'Active') {
      scammers = MockScammersData.getActiveHoneypots();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Scammers & Honeypots',
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
                children: ['All', 'Critical', 'Active'].map((filter) {
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = filter;
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
            // Scammers List
            Expanded(
              child: scammers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: AppTheme.successGreen.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No scammers found',
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
                      itemCount: scammers.length,
                      itemBuilder: (context, index) {
                        final scammer = scammers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              showScammerDetails(scammer);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:
                                      scammer.riskLevel == 'Critical'
                                          ? [
                                              AppTheme.criticalRed.withValues(alpha: 0.1),
                                              AppTheme.cardBackground,
                                            ]
                                          : [
                                              AppTheme.cardBackground.withValues(alpha: 0.8),
                                              AppTheme.surfaceDark.withValues(alpha: 0.6),
                                            ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: scammer.riskLevel == 'Critical'
                                      ? AppTheme.criticalRed.withValues(alpha: 0.5)
                                      : AppTheme.borderColor.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              scammer.name,
                                              style: const TextStyle(
                                                color: AppTheme.textPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              scammer.phoneNumber,
                                              style: const TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 12,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SeverityBadge(
                                              severity: scammer.riskLevel),
                                          const SizedBox(height: 6),
                                          if (scammer.honeypotActive)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppTheme.accentBlue
                                                    .withValues(alpha: 0.2),
                                                border: Border.all(
                                                  color: AppTheme.accentBlue,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppTheme.accentBlue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Text(
                                                    'Active',
                                                    style: TextStyle(
                                                      color: AppTheme
                                                          .accentBlue,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Total Calls',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            scammer.callCount.toString(),
                                            style: const TextStyle(
                                              color: AppTheme.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Region',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            scammer.region,
                                            style: const TextStyle(
                                              color: AppTheme.textPrimary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Last Seen',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            formatTime(scammer.lastSeen),
                                            style: const TextStyle(
                                              color: AppTheme.textPrimary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
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

  void showScammerDetails(dynamic scammer) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scammer.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scammer.phoneNumber,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SeverityBadge(severity: scammer.riskLevel),
            const SizedBox(height: 16),
            buildScammerDetailRow('Total Calls', scammer.callCount.toString()),
            buildScammerDetailRow('Region', scammer.region),
            buildScammerDetailRow('Last Seen', formatTime(scammer.lastSeen)),
            buildScammerDetailRow(
              'Honeypot Active',
              scammer.honeypotActive ? 'Yes' : 'No',
            ),
            const SizedBox(height: 16),
            const Text(
              'Scam Types',
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
              children: scammer.scamTypes
                  .map((type) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.criticalRed.withValues(alpha: 0.2),
                          border: Border.all(color: AppTheme.criticalRed),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            color: AppTheme.criticalRed,
                            fontSize: 11,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Number blocked successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.criticalRed,
                ),
                icon: const Icon(Icons.block),
                label: const Text('Block This Number'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScammerDetailRow(String label, String value) {
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
