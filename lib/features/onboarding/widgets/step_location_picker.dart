import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';

class StepLocationPicker extends StatelessWidget {
  const StepLocationPicker({required this.value, required this.onChanged, super.key});
  final String value;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(initialValue: value, onChanged: onChanged, decoration: InputDecoration(labelText: l10n.locationLabel, hintText: l10n.locationHint, prefixIcon: const Icon(Icons.location_on_outlined), border: const OutlineInputBorder()));
  }
}
