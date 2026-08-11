import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A styled card wrapper used around each onboarding step's input widget.
class OnboardingInputCard extends StatelessWidget {
  const OnboardingInputCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.outlineVariant),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0C0D9488),
          blurRadius: 20,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}
