import 'package:flutter_bloc/flutter_bloc.dart';
import '../../onboarding/models/student_profile_model.dart';
import '../../university_search/models/program_model.dart';
import '../../university_search/models/university_model.dart';
import '../engine/fit_score_calculator.dart';
import '../models/fit_score_result_model.dart';
import 'fit_score_state.dart';

class FitScoreCubit extends Cubit<FitScoreState> {
  FitScoreCubit() : super(const FitScoreInitial());

  /// Calculates the fit score for a single university.
  void calculate({
    required StudentProfileModel profile,
    required UniversityModel university,
    List<ProgramModel>? programs,
  }) {
    emit(const FitScoreCalculating());
    try {
      final result = FitScoreCalculator.calculateFitScore(
        profile: profile,
        university: university,
        programs: programs,
      );
      emit(FitScoreCalculated(result));
    } catch (e) {
      emit(FitScoreError('Failed to calculate fit score: ${e.toString()}'));
    }
  }

  /// Batch calculates scores for a list of universities, returning a map of scores.
  Map<String, FitScoreResultModel> calculateForList({
    required StudentProfileModel profile,
    required List<UniversityModel> universities,
    Map<String, List<ProgramModel>>? programsByUniversity,
  }) {
    final Map<String, FitScoreResultModel> results = {};
    for (final uni in universities) {
      final programs = programsByUniversity?[uni.id];
      results[uni.id] = FitScoreCalculator.calculateFitScore(
        profile: profile,
        university: uni,
        programs: programs,
      );
    }
    return results;
  }
}
