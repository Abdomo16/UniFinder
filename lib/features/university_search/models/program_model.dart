class ProgramModel {
  const ProgramModel({
    required this.id,
    required this.universityId,
    required this.majorName,
    required this.majorNameAr,
    required this.studyMode,
    required this.languageOfInstruction,
  });

  final String id;
  final String universityId;
  final String majorName;
  final String majorNameAr;
  final String studyMode;
  final String languageOfInstruction;

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as String? ?? '',
      universityId: json['university_id'] as String? ?? '',
      majorName: json['major_name'] as String? ?? '',
      majorNameAr: json['major_name_ar'] as String? ?? '',
      studyMode: json['study_mode'] as String? ?? '',
      languageOfInstruction: json['language_of_instruction'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'major_name': majorName,
      'major_name_ar': majorNameAr,
      'study_mode': studyMode,
      'language_of_instruction': languageOfInstruction,
    };
  }
}
