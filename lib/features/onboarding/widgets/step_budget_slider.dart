import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/l10n.dart';

class StepBudgetSlider extends StatelessWidget {
  const StepBudgetSlider({required this.value, required this.onChanged, super.key});
  final double value;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat.decimalPattern(Localizations.localeOf(context).languageCode).format(value.round());
    return Column(children: [
      Text('$amount EGP', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.primary)),
      Slider(value: value, min: 20000, max: 500000, divisions: 48, onChanged: onChanged),
      Text(AppLocalizations.of(context).budgetLabel, style: Theme.of(context).textTheme.bodyLarge),
    ]);
  }
}
