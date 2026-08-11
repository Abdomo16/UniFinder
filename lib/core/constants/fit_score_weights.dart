/// Weights used by [FitScoreCalculator] to compute a student–university
/// compatibility score (values sum to 1.0).
class FitScoreWeights {
  FitScoreWeights._();

  /// How much the grade / admission cutoff match contributes.
  static const double grade = 0.40;

  /// How much the yearly budget vs tuition match contributes.
  static const double budget = 0.30;

  /// How much the location / distance preference contributes.
  static const double location = 0.15;

  /// How much the available majors overlap contributes.
  static const double majorMatch = 0.15;
}
