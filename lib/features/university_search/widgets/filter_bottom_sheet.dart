import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/l10n.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    this.initialMajor,
    this.initialLocation,
    this.initialBudget,
    this.initialScholarship = false,
  });

  final String? initialMajor;
  final String? initialLocation;
  final double? initialBudget;
  final bool initialScholarship;

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    String? major,
    String? location,
    double? budget,
    bool scholarship = false,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => FilterBottomSheet(
        initialMajor: major,
        initialLocation: location,
        initialBudget: budget,
        initialScholarship: scholarship,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedMajor;
  String? _selectedLocation;
  double? _budget;
  bool _scholarship = false;

  final List<String> _majors = [
    'Computer Science',
    'Engineering',
    'Business',
    'Medicine',
    'Pharmacy',
    'Media',
    'Other',
  ];

  final List<String> _governorates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Suez',
  ];

  @override
  void initState() {
    super.initState();
    _selectedMajor = widget.initialMajor;
    _selectedLocation = widget.initialLocation;
    _budget = widget.initialBudget;
    _scholarship = widget.initialScholarship;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Major',
              border: OutlineInputBorder(),
            ),
            initialValue: _selectedMajor,
            items: _majors
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => setState(() => _selectedMajor = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
            initialValue: _selectedLocation,
            items: _governorates
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => setState(() => _selectedLocation = v),
          ),
          const SizedBox(height: 16),
          Text(
            'Max Budget: ${_budget != null ? '${_budget!.toInt()} EGP' : 'Any'}',
          ),
          Slider(
            value: _budget ?? 400000,
            min: 0,
            max: 400000,
            divisions: 40,
            onChanged: (v) => setState(() => _budget = v == 400000 ? null : v),
          ),
          CheckboxListTile(
            title: const Text('Requires Scholarship'),
            value: _scholarship,
            onChanged: (v) => setState(() => _scholarship = v ?? false),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'major': null,
                      'location': null,
                      'budgetMax': null,
                      'scholarshipRequired': false,
                    });
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'major': _selectedMajor,
                      'location': _selectedLocation,
                      'budgetMax': _budget,
                      'scholarshipRequired': _scholarship,
                    });
                  },
                  child: Text(l10n.apply),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
