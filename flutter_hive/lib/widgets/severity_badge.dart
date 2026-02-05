import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SeverityBadge extends StatelessWidget {
  final String severity; // Low, Medium, High, Critical
  final double fontSize;

  const SeverityBadge({
    super.key,
    required this.severity,
    this.fontSize = 12,
  });

  Color getSeverityColor() {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppTheme.criticalRed;
      case 'high':
        return AppTheme.warningOrange;
      case 'medium':
        return AppTheme.primaryPurple;
      case 'low':
        return AppTheme.successGreen;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: getSeverityColor().withOpacity(0.2),
        border: Border.all(color: getSeverityColor(), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        severity,
        style: TextStyle(
          color: getSeverityColor(),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
