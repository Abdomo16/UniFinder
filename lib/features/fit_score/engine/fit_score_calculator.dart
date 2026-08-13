import '../../../core/constants/fit_score_weights.dart';
import '../../../core/utils/distance_calculator.dart';
import '../../onboarding/models/student_profile_model.dart';
import '../../university_search/models/program_model.dart';
import '../../university_search/models/university_model.dart';
import '../models/fit_score_result_model.dart';

/// Extension to define missing fields on the frozen [StudentProfileModel]
extension FitScoreStudentProfileExtensions on StudentProfileModel {
  String get intendedMajor => majors.isNotEmpty ? majors.first : '';
  double get maxAcceptableDistance => 50.0;
  String get preferredUniversityType => 'public';
  String get universityTypeStrictness => 'flexible';
  double get scholarshipNeedPercent => 30.0;
}

class FitScoreCalculator {
  /// Pure function to calculate a 0-100 fit score result for a student and a university.
  static FitScoreResultModel calculateFitScore({
    required StudentProfileModel profile,
    required UniversityModel university,
    List<ProgramModel>? programs,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();

    // 1. Academic Eligibility (Weight: 30%)
    final academicScore = _calculateAcademicScore(profile, university);
    final academicResult = FitScoreFactorResult(
      factorKey: FitScoreFactorKey.academic,
      score: academicScore,
      weight: FitScoreWeights.academicEligibility,
      status: _getStatusForScore(academicScore),
      explanationText: academicScore >= 85
          ? 'Your grades meet the university requirements.'
          : academicScore >= 60
              ? 'Your grades are slightly below the requirements.'
              : 'Your grades do not meet the minimum requirements.',
      explanationTextAr: academicScore >= 85
          ? 'درجاتك تلبي متطلبات الجامعة.'
          : academicScore >= 60
              ? 'درجاتك أقل بقليل من المتطلبات.'
              : 'درجاتك لا تلبي الحد الأدنى من المتطلبات.',
    );

    // 2. Tuition Affordability (Weight: 20%)
    final tuitionScore = _calculateTuitionScore(profile, university);
    final tuitionResult = FitScoreFactorResult(
      factorKey: FitScoreFactorKey.tuition,
      score: tuitionScore,
      weight: FitScoreWeights.tuitionAffordability,
      status: _getStatusForScore(tuitionScore),
      explanationText: tuitionScore >= 85
          ? 'Tuition is fully within your budget.'
          : tuitionScore >= 60
              ? 'Tuition is slightly above your budget.'
              : 'Tuition significantly exceeds your budget.',
      explanationTextAr: tuitionScore >= 85
          ? 'الرسوم الدراسية تقع بالكامل ضمن ميزانيتك.'
          : tuitionScore >= 60
              ? 'الرسوم الدراسية أعلى بقليل من ميزانيتك.'
              : 'الرسوم الدراسية تتجاوز ميزانيتك بشكل كبير.',
    );

    // 3. Major Availability (Weight: 15%)
    final majorScore = _calculateMajorScore(profile, programs);
    final majorResult = FitScoreFactorResult(
      factorKey: FitScoreFactorKey.major,
      score: majorScore,
      weight: FitScoreWeights.majorAvailability,
      status: _getStatusForScore(majorScore),
      explanationText: majorScore == 100
          ? 'Your intended major is available at this university.'
          : 'Your intended major is not available here.',
      explanationTextAr: majorScore == 100
          ? 'تخصصك المطلوب متاح في هذه الجامعة.'
          : 'تخصصك المطلوب غير متاح هنا.',
    );

    // 4. Distance (Weight: 15%)
    double profileLat = 0.0;
    double profileLon = 0.0;
    if (profile.location.isNotEmpty) {
      final parts = profile.location.split(',');
      if (parts.length == 2) {
        profileLat = double.tryParse(parts[0]) ?? 0.0;
        profileLon = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    final distanceKm = DistanceCalculator.kilometresBetween(
      profileLat,
      profileLon,
      university.latitude,
      university.longitude,
    );
    final distanceScore = _calculateDistanceScore(profile, distanceKm);
    final formattedDist = distanceKm.toStringAsFixed(1);
    final distanceResult = FitScoreFactorResult(
      factorKey: FitScoreFactorKey.distance,
      score: distanceScore,
      weight: FitScoreWeights.distance,
      status: _getStatusForScore(distanceScore),
      explanationText: distanceScore >= 85
          ? 'Convenient distance: $formattedDist km from your location.'
          : 'Located $formattedDist km away, which exceeds your ideal distance.',
      explanationTextAr: distanceScore >= 85
          ? 'مسافة مناسبة: $formattedDist كم من موقعك.'
          : 'تقع على بعد $formattedDist كم، مما يتجاوز مسافتك المثالية.',
    );

    // 5. University Type Preference (Weight: 10%)
    final typeScore = _calculateUniversityTypeScore(profile, university);
    final typeResult = FitScoreFactorResult(
      factorKey: FitScoreFactorKey.universityType,
      score: typeScore,
      weight: FitScoreWeights.universityTypePreference,
      status: _getStatusForScore(typeScore),
      explanationText: typeScore >= 85
          ? 'Matches your preferred university type.'
          : typeScore >= 50
              ? 'Matches partially/flexible preferences.'
              : 'Does not match your preferred university type.',
      explanationTextAr: typeScore >= 85
          ? 'يطابق نوع الجامعة المفضل لديك.'
          : typeScore >= 50
              ? 'يطابق جزئياً مع تفضيلاتك المرنة.'
              : 'لا يطابق نوع الجامعة المفضل لديك.',
    );

    // 6. Application Deadline (Weight: 5%)
    final (deadlineScore, daysRemaining) = _calculateDeadlineScore(university, now);
    final deadlineResult = FitScoreFactorResult(
      factorKey: FitScoreFactorKey.deadline,
      score: deadlineScore,
      weight: FitScoreWeights.applicationDeadline,
      status: _getStatusForScore(deadlineScore),
      explanationText: deadlineScore == 0
          ? 'The application deadline has already passed.'
          : daysRemaining >= 30
              ? 'Ample time left to apply ($daysRemaining days).'
              : 'Deadline is approaching ($daysRemaining days remaining).',
      explanationTextAr: deadlineScore == 0
          ? 'لقد انتهى الموعد النهائي لتقديم الطلبات بالفعل.'
          : daysRemaining >= 30
              ? 'يتوفر متسع من الوقت للتقديم ($daysRemaining يوماً).'
              : 'يقترب الموعد النهائي ($daysRemaining يوماً متبقية).',
    );

    // 7. Scholarships (Weight: 5%)
    final scholarshipScore = _calculateScholarshipScore(profile, university);
    final scholarshipResult = FitScoreFactorResult(
      factorKey: FitScoreFactorKey.scholarship,
      score: scholarshipScore,
      weight: FitScoreWeights.scholarships,
      status: _getStatusForScore(scholarshipScore),
      explanationText: scholarshipScore >= 85
          ? 'Generous scholarship match (up to ${university.scholarshipMaxPercent.toStringAsFixed(0)}%).'
          : scholarshipScore >= 50
              ? 'Partial scholarship matching: ${university.scholarshipMaxPercent.toStringAsFixed(0)}% offered.'
              : 'Scholarship options are limited or do not meet your needs.',
      explanationTextAr: scholarshipScore >= 85
          ? 'منحة دراسية سخية متوافقة (تصل إلى ${university.scholarshipMaxPercent.toStringAsFixed(0)}٪).'
          : scholarshipScore >= 50
              ? 'تطابق جزئي للمنحة: توفر ${university.scholarshipMaxPercent.toStringAsFixed(0)}٪.'
              : 'خيارات المنح الدراسية محدودة أو لا تلبي احتياجاتك.',
    );

    final breakdown = [
      academicResult,
      tuitionResult,
      majorResult,
      distanceResult,
      typeResult,
      deadlineResult,
      scholarshipResult,
    ];

    double weightedSum = 0.0;
    for (final factor in breakdown) {
      weightedSum += factor.score * factor.weight;
    }
    final overallScore = weightedSum.round().clamp(0, 100);

    return FitScoreResultModel(
      universityId: university.id,
      overallScore: overallScore,
      breakdown: breakdown,
    );
  }

  static FitScoreStatus _getStatusForScore(int score) {
    if (score >= 85) return FitScoreStatus.good;
    if (score >= 60) return FitScoreStatus.warning;
    return FitScoreStatus.poor;
  }

  static int _calculateAcademicScore(
      StudentProfileModel profile, UniversityModel university) {
    if (profile.grade >= university.minGrade) {
      return 100;
    }
    if (university.minGrade == 0) {
      return 100;
    }
    final ratio = profile.grade / university.minGrade;
    if (ratio >= 0.90) {
      final scaled = ((ratio - 0.90) / 0.10 * 100).round();
      return scaled.clamp(0, 100);
    }
    return 0;
  }

  static int _calculateTuitionScore(
      StudentProfileModel profile, UniversityModel university) {
    if (university.tuitionPerYear <= profile.yearlyBudget) {
      return 100;
    }
    if (profile.yearlyBudget == 0) {
      return 0;
    }
    final ratio = university.tuitionPerYear / profile.yearlyBudget;
    if (ratio <= 1.5) {
      final scaled = ((1.5 - ratio) / 0.5 * 100).round();
      return scaled.clamp(0, 100);
    }
    return 0;
  }

  static int _calculateMajorScore(
      StudentProfileModel profile, List<ProgramModel>? programs) {
    if (programs == null || programs.isEmpty) {
      return 0;
    }
    final target = profile.intendedMajor.toLowerCase().trim();
    if (target.isEmpty) {
      return 0;
    }
    final hasMajor = programs.any((p) =>
        p.majorName.toLowerCase().trim() == target ||
        p.majorNameAr.toLowerCase().trim() == target);
    return hasMajor ? 100 : 0;
  }

  static int _calculateDistanceScore(
      StudentProfileModel profile, double distanceKm) {
    if (profile.maxAcceptableDistance == 0) {
      return 100;
    }
    if (distanceKm <= profile.maxAcceptableDistance) {
      return 100;
    }
    final ratio = distanceKm / profile.maxAcceptableDistance;
    if (ratio <= 2.0) {
      final scaled = ((2.0 - ratio) / 1.0 * 100).round();
      return scaled.clamp(0, 100);
    }
    return 0;
  }

  static int _calculateUniversityTypeScore(
      StudentProfileModel profile, UniversityModel university) {
    if (profile.preferredUniversityType.toLowerCase().trim() ==
        university.universityType.toLowerCase().trim()) {
      return 100;
    }
    final strictness = profile.universityTypeStrictness.toLowerCase().trim();
    if (strictness == 'strict' || strictness == 'high') {
      return 0;
    } else if (strictness == 'flexible' || strictness == 'medium') {
      return 50;
    }
    return 100;
  }

  static (int, int) _calculateDeadlineScore(
      UniversityModel university, DateTime now) {
    final deadline = university.applicationDeadline;
    if (deadline == null) {
      return (100, 999);
    }
    if (now.isAfter(deadline)) {
      return (0, 0);
    }
    final daysRemaining = deadline.difference(now).inDays;
    if (daysRemaining >= 30) {
      return (100, daysRemaining);
    }
    final score = ((daysRemaining / 30.0) * 100).round().clamp(0, 100);
    return (score, daysRemaining);
  }

  static int _calculateScholarshipScore(
      StudentProfileModel profile, UniversityModel university) {
    if (profile.scholarshipNeedPercent <= 0) {
      return 100;
    }
    if (university.scholarshipMaxPercent >= profile.scholarshipNeedPercent) {
      return 100;
    }
    final ratio = university.scholarshipMaxPercent / profile.scholarshipNeedPercent;
    return (ratio * 100).round().clamp(0, 100);
  }
}
