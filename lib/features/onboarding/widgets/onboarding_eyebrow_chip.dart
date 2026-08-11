import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A small pill-shaped label displayed above the welcome title.
class OnboardingEyebrowChip extends StatelessWidget {
  const OnboardingEyebrowChip({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: AppColors.primary),
    ),
  );
}
