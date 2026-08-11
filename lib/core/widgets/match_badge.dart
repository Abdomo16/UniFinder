import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum MatchLevel { high, medium, low }

/// Small coloured badge showing 🟢🟡🔴 compatibility levels.
class MatchBadge extends StatelessWidget {
  const MatchBadge({required this.score, super.key});

  /// Score between 0 and 100.
  final double score;

  MatchLevel get _level {
    if (score >= 70) return MatchLevel.high;
    if (score >= 40) return MatchLevel.medium;
    return MatchLevel.low;
  }

  @override
  Widget build(BuildContext context) {
    final (emoji, color) = switch (_level) {
      MatchLevel.high => ('🟢', AppColors.primary),
      MatchLevel.medium => ('🟡', AppColors.secondary),
      MatchLevel.low => ('🔴', AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            '${score.round()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
