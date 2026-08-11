import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Bottom bar showing step-dot progress and the primary action button.
class OnboardingBottomActions extends StatelessWidget {
  const OnboardingBottomActions({
    required this.currentStep,
    required this.stepCount,
    required this.isSummary,
    required this.buttonLabel,
    required this.onPressed,
    super.key,
  });

  final int currentStep;
  final int stepCount;
  final bool isSummary;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
    decoration: const BoxDecoration(
      color: AppColors.surfaceContainerLowest,
      border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      boxShadow: [
        BoxShadow(
          color: Color(0x0C0D9488),
          blurRadius: 20,
          offset: Offset(0, -4),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Row(
          children: [
            Row(
              children: List.generate(
                stepCount,
                (index) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsetsDirectional.only(end: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= currentStep
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size(136, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              icon: Icon(isSummary ? Icons.auto_awesome : Icons.arrow_forward),
              label: Text(buttonLabel),
            ),
          ],
        ),
      ),
    ),
  );
}
