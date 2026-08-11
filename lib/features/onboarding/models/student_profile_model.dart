class StudentProfileModel {
  const StudentProfileModel({
    this.grade = 80,
    this.yearlyBudget = 100000,
    this.location = '',
    this.majors = const [],
  });

  final double grade;
  final double yearlyBudget;
  final String location;
  final List<String> majors;

  StudentProfileModel copyWith({
    double? grade,
    double? yearlyBudget,
    String? location,
    List<String>? majors,
  }) => StudentProfileModel(
        grade: grade ?? this.grade,
        yearlyBudget: yearlyBudget ?? this.yearlyBudget,
        location: location ?? this.location,
        majors: majors ?? this.majors,
      );
}
