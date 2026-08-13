import 'package:equatable/equatable.dart';
import '../models/university_model.dart';

enum UniversitySearchStatus { initial, loading, loaded, error }

class UniversitySearchState extends Equatable {
  const UniversitySearchState({
    this.status = UniversitySearchStatus.initial,
    this.universities = const [],
    this.hasMore = true,
    this.currentPage = 0,
    this.query = '',
    this.selectedMajor,
    this.selectedLocation,
    this.maxBudget,
    this.maxMinGrade,
    this.scholarshipRequired = false,
    this.errorMessage,
  });

  final UniversitySearchStatus status;
  final List<UniversityModel> universities;
  final bool hasMore;
  final int currentPage;
  final String query;
  final String? selectedMajor;
  final String? selectedLocation;
  final double? maxBudget;
  final double? maxMinGrade;
  final bool scholarshipRequired;
  final String? errorMessage;

  UniversitySearchState copyWith({
    UniversitySearchStatus? status,
    List<UniversityModel>? universities,
    bool? hasMore,
    int? currentPage,
    String? query,
    String? selectedMajor,
    String? selectedLocation,
    double? maxBudget,
    double? maxMinGrade,
    bool? scholarshipRequired,
    String? errorMessage,
  }) {
    return UniversitySearchState(
      status: status ?? this.status,
      universities: universities ?? this.universities,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      query: query ?? this.query,
      selectedMajor: selectedMajor ?? this.selectedMajor,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      maxBudget: maxBudget ?? this.maxBudget,
      maxMinGrade: maxMinGrade ?? this.maxMinGrade,
      scholarshipRequired: scholarshipRequired ?? this.scholarshipRequired,
      errorMessage: errorMessage, // null to clear error unless specified
    );
  }

  @override
  List<Object?> get props => [
    status,
    universities,
    hasMore,
    currentPage,
    query,
    selectedMajor,
    selectedLocation,
    maxBudget,
    maxMinGrade,
    scholarshipRequired,
    errorMessage,
  ];
}
