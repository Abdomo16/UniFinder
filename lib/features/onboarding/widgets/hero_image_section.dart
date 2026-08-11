import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HeroImageSection extends StatelessWidget {
  const HeroImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return SizedBox(
      width: double.infinity,
      height: 240,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.primaryContainer,
              image: const DecorationImage(
                fit: BoxFit.cover,
                opacity: .72,
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=900&q=80',
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 16,
            start: 16,
            end: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: .92),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primaryContainer,
                    child: Icon(
                      Icons.school,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? 'أكثر من 500+' : 'More than 500+',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        isArabic
                            ? 'جامعة حول العالم'
                            : 'universities worldwide',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
