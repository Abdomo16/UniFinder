import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/l10n.dart';

class StepGradeInput extends StatelessWidget {
  const StepGradeInput({required this.value, required this.onChanged, super.key});
  final double value;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('${value.round()}%', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.primary)),
      Slider(value: value, min: 50, max: 100, divisions: 50, label: '${value.round()}%', onChanged: onChanged),
      Text(AppLocalizations.of(context).gradeLabel, style: Theme.of(context).textTheme.bodyLarge),
    ]);
  }
}
