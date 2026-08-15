/// Weights used by [FitScoreCalculator] to compute a student–university
/// compatibility score (values sum to 1.0).
class FitScoreWeights {
  FitScoreWeights._();

  static const double academicEligibility = 0.30;
  static const double tuitionAffordability = 0.20;
  static const double majorAvailability = 0.15;
  static const double distance = 0.15;
  static const double universityTypePreference = 0.10;
  static const double applicationDeadline = 0.05;
  static const double scholarships = 0.05;

  /// Returns the sum of all weight factors.
  static double get totalSum =>
      academicEligibility +
      tuitionAffordability +
      majorAvailability +
      distance +
      universityTypePreference +
      applicationDeadline +
      scholarships;

  /// Asserts that weights sum to exactly 1.0.
  static bool get isValid => (totalSum - 1.0).abs() < 1e-9;
}
