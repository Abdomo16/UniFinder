import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../models/student_profile_model.dart';

class OnboardingSummaryScreen extends StatelessWidget {
  const OnboardingSummaryScreen({required this.profile, super.key});
  final StudentProfileModel profile;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.celebration_outlined, size: 96, color: Colors.teal),
      const SizedBox(height: 24),
      Text(l10n.summaryTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 12), Text(l10n.summaryBody, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
      if (profile.majors.isNotEmpty) ...[const SizedBox(height: 24), Text('${l10n.selectedMajors}: ${profile.majors.join(', ')}', textAlign: TextAlign.center)],
    ]);
  }
}
