import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../onboarding/repositories/student_profile_repository.dart';
import '../../fit_score/engine/fit_score_calculator.dart';
import '../models/program_model.dart';
import '../models/university_model.dart';
import '../repositories/university_repository.dart';
import 'university_search_state.dart';

class UniversitySearchCubit extends Cubit<UniversitySearchState> {
  UniversitySearchCubit({
    UniversityRepository? repository,
    StudentProfileRepository? profileRepository,
  })  : _repository = repository ?? UniversityRepository(),
        _profileRepository = profileRepository ?? StudentProfileRepository(),
        super(const UniversitySearchState());

  final UniversityRepository _repository;
  final StudentProfileRepository _profileRepository;
  Timer? _debounceTimer;

  Future<void> loadInitial() async {
    emit(
      state.copyWith(
        status: UniversitySearchStatus.loading,
        currentPage: 0,
        universities: [],
        hasMore: true,
      ),
    );
    await _fetchData();
  }

  Future<void> loadMore() async {
    if (state.status == UniversitySearchStatus.loading || !state.hasMore) {
      return;
    }

    emit(state.copyWith(status: UniversitySearchStatus.loading));
    await _fetchData(page: state.currentPage + 1);
  }

  void search(String query) {
    if (state.query == query) {
      return;
    }

    emit(state.copyWith(query: query));

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      loadInitial();
    });
  }

  void applyFilters({
    String? major,
    String? location,
    double? budgetMax,
    double? minGradeMax,
    bool scholarshipRequired = false,
  }) {
    emit(
      state.copyWith(
        selectedMajor: major,
        selectedLocation: location,
        maxBudget: budgetMax,
        maxMinGrade: minGradeMax,
        scholarshipRequired: scholarshipRequired,
      ),
    );
    loadInitial();
  }

  Future<void> _fetchData({int page = 0}) async {
    try {
      final results = await _repository
          .fetchUniversities(
            query: state.query,
            major: state.selectedMajor,
            location: state.selectedLocation,
            budgetMax: state.maxBudget,
            minGradeMax: state.maxMinGrade,
            scholarshipRequired: state.scholarshipRequired,
            page: page,
          )
          .timeout(const Duration(seconds: 10));

      final profile = await _profileRepository.getProfile();
      final updatedResults = <UniversityModel>[];

      for (final uni in results) {
        final programs = await _repository.fetchProgramsForUniversity(uni.id);
        final fitResult = FitScoreCalculator.calculateFitScore(
          profile: profile,
          university: uni,
          programs: programs,
        );
        updatedResults.add(uni.copyWith(fitScore: fitResult.overallScore));
      }

      final hasMore = results.length == 10; // pageSize is 10

      emit(
        state.copyWith(
          status: UniversitySearchStatus.loaded,
          universities: page == 0
              ? updatedResults
              : [...state.universities, ...updatedResults],
          currentPage: page,
          hasMore: hasMore,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UniversitySearchStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
