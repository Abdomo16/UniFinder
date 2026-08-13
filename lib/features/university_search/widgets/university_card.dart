import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/university_model.dart';

/// Small circular badge showing compatibility percentage.
class FitScoreBadge extends StatelessWidget {
  const FitScoreBadge({required this.score, super.key});
  final int score;

  Color get _color {
    if (score >= 85) return AppColors.primary;
    if (score >= 60) return AppColors.secondary;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 3,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
            ),
          ),
          Text(
            '$score%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

class UniversityCard extends StatelessWidget {
  const UniversityCard({required this.university, super.key});

  final UniversityModel university;

  String _getTuitionTier() {
    if (university.tuitionPerYear <= 25000) return '\$';
    if (university.tuitionPerYear <= 80000) return '\$\$';
    return '\$\$\$';
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final String name = isRtl && university.nameAr.isNotEmpty
        ? university.nameAr
        : university.name;
    final String city = isRtl && university.cityAr.isNotEmpty
        ? university.cityAr
        : university.city;
    final String country = isRtl ? 'مصر' : 'Egypt';

    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shadowColor: AppColors.primary.withAlpha(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.surfaceVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () =>
                context.push('/university_detail', extra: university.id),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Cover Image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    university.imageUrl.isNotEmpty
                        ? university.imageUrl
                        : 'https://via.placeholder.com/400x225?text=No+Image',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
                // Bottom content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${university.universityType.toUpperCase()} UNIVERSITY', // Basic tagline placeholder
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _Chip(
                            icon: Icons.location_on_outlined,
                            label: '$city, $country',
                          ),
                          _Chip(
                            icon: Icons.payments_outlined,
                            label: _getTuitionTier(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Conditional Top Match Badge
        if (university.fitScore != null && university.fitScore! >= 85)
          Positioned(
            top: 16,
            left: isRtl ? null : 16,
            right: isRtl ? 16 : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.surfaceVariant),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: AppColors.secondary, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Top 10 Match',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

        // Fit Score indicator
        if (university.fitScore != null)
          Positioned(
            top: 16,
            right: isRtl ? null : 16,
            left: isRtl ? 16 : null,
            child: FitScoreBadge(score: university.fitScore!),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
