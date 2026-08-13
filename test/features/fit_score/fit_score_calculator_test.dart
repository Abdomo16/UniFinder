import 'package:flutter_test/flutter_test.dart';
import 'package:uniifinder/core/constants/fit_score_weights.dart';
import 'package:uniifinder/features/fit_score/engine/fit_score_calculator.dart';
import 'package:uniifinder/features/fit_score/models/fit_score_result_model.dart';
import 'package:uniifinder/features/onboarding/models/student_profile_model.dart';
import 'package:uniifinder/features/university_search/models/program_model.dart';
import 'package:uniifinder/features/university_search/models/university_model.dart';

void main() {
  group('FitScoreWeights Tests', () {
    test('Weights sum up to exactly 1.0', () {
      expect(FitScoreWeights.totalSum, closeTo(1.0, 1e-9));
      expect(FitScoreWeights.isValid, isTrue);
    });
  });

  group('FitScoreCalculator Tests', () {
    final referenceDate = DateTime(2026, 8, 13, 12, 0, 0);

    // Setup a great match profile
    const greatProfile = StudentProfileModel(
      grade: 95.0,
      yearlyBudget: 20000.0,
      location: '31.95,35.91', // Coordinates as string
      majors: ['Computer Science'],
    );

    // Setup a great match university
    final greatUniversity = UniversityModel(
      id: 'uni_great',
      name: 'Great University',
      nameAr: 'الجامعة الرائعة',
      city: 'Amman',
      cityAr: 'عمان',
      governorate: 'Amman',
      tuitionPerYear: 15000.0,
      minGrade: 80.0,
      universityType: 'public',
      applicationDeadline: DateTime(2026, 9, 30),
      scholarshipMaxPercent: 50.0,
      imageUrl: '',
      dataSource: 'Ministry',
      lastVerifiedAt: DateTime(2026, 1, 1),
      latitude: 31.96, // Very close
      longitude: 35.92,
    );

    const greatPrograms = [
      ProgramModel(
        id: 'prog_cs',
        universityId: 'uni_great',
        majorName: 'Computer Science',
        majorNameAr: 'علم الحاسوب',
        studyMode: 'Full-time',
        languageOfInstruction: 'English',
      ),
    ];

    test('Great match scores high and all breakdown factors are good/warning', () {
      final result = FitScoreCalculator.calculateFitScore(
        profile: greatProfile,
        university: greatUniversity,
        programs: greatPrograms,
        referenceDate: referenceDate,
      );

      expect(result.overallScore, greaterThanOrEqualTo(85));
      for (final factor in result.breakdown) {
        expect(factor.status, isNot(FitScoreStatus.poor));
      }
    });

    test('Poor match scores low when requirements are not met', () {
      const poorProfile = StudentProfileModel(
        grade: 55.0,
        yearlyBudget: 5000.0,
        location: '31.95,35.91',
        majors: ['Medicine'],
      );

      final poorUniversity = UniversityModel(
        id: 'uni_poor',
        name: 'Expensive Private University',
        nameAr: 'الجامعة الخاصة المكلفة',
        city: 'Irbid',
        cityAr: 'إربد',
        governorate: 'Irbid',
        tuitionPerYear: 25000.0, // over budget
        minGrade: 90.0, // grade below minimum
        universityType: 'private', // mismatch
        applicationDeadline: DateTime(2026, 9, 30),
        scholarshipMaxPercent: 10.0,
        imageUrl: '',
        dataSource: 'Ministry',
        lastVerifiedAt: DateTime(2026, 1, 1),
        latitude: 32.55, // far away
        longitude: 35.85,
      );

      const poorPrograms = [
        ProgramModel(
          id: 'prog_art',
          universityId: 'uni_poor',
          majorName: 'Fine Arts',
          majorNameAr: 'الفنون الجميلة',
          studyMode: 'Full-time',
          languageOfInstruction: 'Arabic',
        ),
      ];

      final result = FitScoreCalculator.calculateFitScore(
        profile: poorProfile,
        university: poorUniversity,
        programs: poorPrograms,
        referenceDate: referenceDate,
      );

      expect(result.overallScore, lessThan(40));
      final academicFactor = result.breakdown.firstWhere((e) => e.factorKey == FitScoreFactorKey.academic);
      final tuitionFactor = result.breakdown.firstWhere((e) => e.factorKey == FitScoreFactorKey.tuition);
      final majorFactor = result.breakdown.firstWhere((e) => e.factorKey == FitScoreFactorKey.major);

      expect(academicFactor.status, equals(FitScoreStatus.poor));
      expect(tuitionFactor.status, equals(FitScoreStatus.poor));
      expect(majorFactor.status, equals(FitScoreStatus.poor));
    });

    test('Deadline-passed case scores 0 for deadline factor without crashing', () {
      final lateUniversity = UniversityModel(
        id: 'uni_late',
        name: 'Late University',
        nameAr: 'الجامعة المتأخرة',
        city: 'Amman',
        cityAr: 'عمان',
        governorate: 'Amman',
        tuitionPerYear: 10000.0,
        minGrade: 70.0,
        universityType: 'public',
        applicationDeadline: DateTime(2026, 8, 10), // passed
        scholarshipMaxPercent: 0.0,
        imageUrl: '',
        dataSource: 'Ministry',
        lastVerifiedAt: DateTime(2026, 1, 1),
        latitude: 31.95,
        longitude: 35.91,
      );

      final result = FitScoreCalculator.calculateFitScore(
        profile: greatProfile,
        university: lateUniversity,
        programs: greatPrograms,
        referenceDate: referenceDate,
      );

      final deadlineFactor = result.breakdown.firstWhere((e) => e.factorKey == FitScoreFactorKey.deadline);
      expect(deadlineFactor.score, equals(0));
      expect(deadlineFactor.status, equals(FitScoreStatus.poor));
    });

    test('Missing or null optional fields do not throw and handle gracefully', () {
      final result = FitScoreCalculator.calculateFitScore(
        profile: greatProfile,
        university: greatUniversity,
        programs: null,
        referenceDate: referenceDate,
      );

      expect(result.overallScore, isA<int>());
      final majorFactor = result.breakdown.firstWhere((e) => e.factorKey == FitScoreFactorKey.major);
      expect(majorFactor.score, equals(0));
      expect(majorFactor.status, equals(FitScoreStatus.poor));
    });
  });
}
