import 'package:flutter/material.dart';
import 'package:flutter_hive/theme/app_theme.dart';
import 'package:flutter_hive/services/api_service.dart';

class IntelligenceReportScreen extends StatefulWidget {
  const IntelligenceReportScreen({Key? key}) : super(key: key);

  @override
  State<IntelligenceReportScreen> createState() =>
      _IntelligenceReportScreenState();
}

class _IntelligenceReportScreenState extends State<IntelligenceReportScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _reportData;
  String? _error;
  int _selectedDays = 7;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getIntelligenceReport(days: _selectedDays);
      setState(() {
        _reportData = result['report'];
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Intelligence Report'),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppTheme.accentBlue),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPeriodButton('7 Days', 7),
                      _buildPeriodButton('30 Days', 30),
                      _buildPeriodButton('90 Days', 90),
                    ],
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

                  // Report Content
                  if (_reportData != null) ...[
                    // Summary Stats
                    _buildStatCard(
                      'Total Suspicious Messages',
                      '${_reportData!['totalMessages']}',
                      AppTheme.accentBlue,
                      Icons.warning,
                    ),
                    const SizedBox(height: 12),

                    // Spam Types
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accentCyan.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Threat Distribution',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentBlue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...((_reportData!['spamTypes'] as Map?)
                                  ?.entries
                                  .map<Widget>((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accentCyan
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${entry.value}',
                                          style: const TextStyle(
                                            color: AppTheme.accentCyan,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList() ??
                              []),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Top Phone Numbers
                    if ((_reportData!['topPhoneNumbers'] as List?)
                            ?.isNotEmpty ??
                        false)
                      _buildIntelligenceSection(
                        'Suspicious Phone Numbers',
                        _reportData!['topPhoneNumbers'] as List,
                        Colors.red,
                      ),
                    const SizedBox(height: 16),

                    // Top Emails
                    if ((_reportData!['topEmails'] as List?)?.isNotEmpty ??
                        false)
                      _buildIntelligenceSection(
                        'Suspicious Email Addresses',
                        _reportData!['topEmails'] as List,
                        Colors.orange,
                      ),
                    const SizedBox(height: 16),

                    // Bank Names
                    if ((_reportData!['topBanks'] as List?)?.isNotEmpty ??
                        false)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.accentCyan.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bank Names Used in Scams',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...(_reportData!['topBanks'] as List)
                                .map<Widget>((entry) {
                              final bankName =
                                  entry is List ? entry[0] : entry;
                              final count = entry is List ? entry[1] : 0;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      bankName,
                                      style: const TextStyle(
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '$count',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Suspicious URLs
                    if ((_reportData!['suspiciousUrls'] as List?)
                            ?.isNotEmpty ??
                        false)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Malicious URLs Detected',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...(_reportData!['suspiciousUrls'] as List)
                                .take(5)
                                .map<Widget>((url) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    url,
                                    style: TextStyle(
                                      color: Colors.red.shade300,
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Export Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Report exported (for law enforcement)',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.download),
                        label: const Text(
                          'Export for Law Enforcement',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildPeriodButton(String label, int days) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDays = days;
        });
        _fetchReport();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedDays == days
            ? AppTheme.accentBlue
            : AppTheme.cardColor,
        side: BorderSide(
          color: _selectedDays == days
              ? AppTheme.accentBlue
              : AppTheme.accentCyan.withOpacity(0.3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _selectedDays == days ? Colors.white : AppTheme.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntelligenceSection(
    String title,
    List items,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          ...items.take(5).map<Widget>((entry) {
            final value =
                entry is List ? '${entry[0]} (${entry[1]})' : entry.toString();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SelectableText(
                value,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            );
          }).toList(),
          if (items.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '+${items.length - 5} more',
                style: TextStyle(
                  color: color.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
