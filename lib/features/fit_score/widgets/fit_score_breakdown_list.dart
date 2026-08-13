import 'package:flutter/material.dart';
import '../../../core/widgets/match_badge.dart';
import '../models/fit_score_result_model.dart';

class FitScoreBreakdownList extends StatelessWidget {
  final List<FitScoreFactorResult> breakdown;

  const FitScoreBreakdownList({
    super.key,
    required this.breakdown,
  });

  String _getFactorLabel(FitScoreFactorKey key, bool isAr) {
    switch (key) {
      case FitScoreFactorKey.academic:
        return isAr ? 'الأكاديمي' : 'Academic';
      case FitScoreFactorKey.tuition:
        return isAr ? 'الرسوم الدراسية' : 'Tuition';
      case FitScoreFactorKey.major:
        return isAr ? 'التخصص' : 'Major';
      case FitScoreFactorKey.distance:
        return isAr ? 'المسافة' : 'Distance';
      case FitScoreFactorKey.universityType:
        return isAr ? 'نوع الجامعة' : 'University Type';
      case FitScoreFactorKey.deadline:
        return isAr ? 'الموعد النهائي' : 'Deadline';
      case FitScoreFactorKey.scholarship:
        return isAr ? 'المنح الدراسية' : 'Scholarships';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: breakdown.length,
      separatorBuilder: (context, index) => const Divider(height: 16),
      itemBuilder: (context, index) {
        final item = breakdown[index];
        final explanation = isRtl ? item.explanationTextAr : item.explanationText;
        final label = _getFactorLabel(item.factorKey, isRtl);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MatchBadge(score: item.score.toDouble()),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      explanation,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
