import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/university_repository.dart';
import 'university_search_state.dart';

class UniversitySearchCubit extends Cubit<UniversitySearchState> {
  UniversitySearchCubit({UniversityRepository? repository})
    : _repository = repository ?? UniversityRepository(),
      super(const UniversitySearchState());

  final UniversityRepository _repository;
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

      final hasMore = results.length == 10; // pageSize is 10

      emit(
        state.copyWith(
          status: UniversitySearchStatus.loaded,
          universities: page == 0
              ? results
              : [...state.universities, ...results],
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
