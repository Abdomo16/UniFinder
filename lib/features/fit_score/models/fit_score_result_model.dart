enum FitScoreFactorKey {
  academic,
  tuition,
  major,
  distance,
  universityType,
  deadline,
  scholarship,
}

enum FitScoreStatus {
  good,    // 🟢
  warning, // 🟡
  poor,    // 🔴
}

class FitScoreFactorResult {
  final FitScoreFactorKey factorKey;
  final int score; // 0-100
  final double weight;
  final FitScoreStatus status;
  final String explanationText;
  final String explanationTextAr;

  const FitScoreFactorResult({
    required this.factorKey,
    required this.score,
    required this.weight,
    required this.status,
    required this.explanationText,
    required this.explanationTextAr,
  });

  factory FitScoreFactorResult.fromJson(Map<String, dynamic> json) {
    return FitScoreFactorResult(
      factorKey: FitScoreFactorKey.values.firstWhere(
        (e) => e.name == json['factorKey'],
      ),
      score: json['score'] as int,
      weight: (json['weight'] as num).toDouble(),
      status: FitScoreStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      explanationText: json['explanationText'] as String,
      explanationTextAr: json['explanationTextAr'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'factorKey': factorKey.name,
      'score': score,
      'weight': weight,
      'status': status.name,
      'explanationText': explanationText,
      'explanationTextAr': explanationTextAr,
    };
  }
}

class FitScoreResultModel {
  final String universityId;
  final int overallScore; // 0-100
  final List<FitScoreFactorResult> breakdown;

  const FitScoreResultModel({
    required this.universityId,
    required this.overallScore,
    required this.breakdown,
  });

  factory FitScoreResultModel.fromJson(Map<String, dynamic> json) {
    return FitScoreResultModel(
      universityId: json['universityId'] as String,
      overallScore: json['overallScore'] as int,
      breakdown: (json['breakdown'] as List)
          .map((e) => FitScoreFactorResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'universityId': universityId,
      'overallScore': overallScore,
      'breakdown': breakdown.map((e) => e.toJson()).toList(),
    };
  }
}
