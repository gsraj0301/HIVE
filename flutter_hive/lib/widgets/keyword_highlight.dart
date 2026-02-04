import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KeywordHighlight extends StatelessWidget {
  final String keyword;
  final bool isHighlighted;

  const KeywordHighlight({
    Key? key,
    required this.keyword,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppTheme.criticalRed.withOpacity(0.2)
            : AppTheme.accentBlue.withOpacity(0.1),
        border: Border.all(
          color: isHighlighted ? AppTheme.criticalRed : AppTheme.accentBlue,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        keyword,
        style: TextStyle(
          color: isHighlighted ? AppTheme.criticalRed : AppTheme.accentBlue,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
