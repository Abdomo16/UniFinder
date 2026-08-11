import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class StepMajorSelector extends StatelessWidget {
  const StepMajorSelector({
    required this.selected,
    required this.onToggle,
    super.key,
  });

  final List<String> selected;
  final ValueChanged<String> onToggle;

  static const _majors = <_MajorOption>[
    _MajorOption('Computer Science', 'علوم الحاسب', Icons.terminal_rounded),
    _MajorOption('Engineering', 'الهندسة', Icons.engineering_outlined),
    _MajorOption('Business', 'إدارة الأعمال', Icons.trending_up_rounded),
    _MajorOption('Medicine', 'الطب', Icons.medical_services_outlined),
    _MajorOption('Pharmacy', 'الصيدلة', Icons.medication_outlined),
    _MajorOption('Media', 'الإعلام', Icons.movie_outlined),
    _MajorOption('Other', 'أخرى', Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _majors.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final major = _majors[index];
        final isSelected = selected.contains(major.value);
        return Semantics(
          selected: isSelected,
          button: true,
          label: isArabic ? major.arabicLabel : major.englishLabel,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onToggle(major.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? const [BoxShadow(color: Color(0x1400685F), blurRadius: 12, offset: Offset(0, 4))]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    major.icon,
                    size: 34,
                    color: isSelected ? AppColors.onPrimaryContainer : AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      isArabic ? major.arabicLabel : major.englishLabel,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MajorOption {
  const _MajorOption(this.value, this.arabicLabel, this.icon);

  final String value;
  final String arabicLabel;
  final IconData icon;

  String get englishLabel => value;
}
