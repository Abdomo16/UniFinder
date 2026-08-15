import 'package:shared_preferences/shared_preferences.dart';

import '../models/student_profile_model.dart';

class StudentProfileRepository {
  static const _completedKey = 'onboarding_completed';

  Future<void> save(StudentProfileModel profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_completedKey, true);
    await preferences.setDouble('student_grade', profile.grade);
    await preferences.setDouble('student_budget', profile.yearlyBudget);
    await preferences.setString('student_location', profile.location);
    await preferences.setStringList('student_majors', profile.majors);
  }

  Future<bool> isCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_completedKey) ?? false;
  }

  Future<StudentProfileModel> getProfile() async {
    final preferences = await SharedPreferences.getInstance();
    final grade = preferences.getDouble('student_grade') ?? 80.0;
    final budget = preferences.getDouble('student_budget') ?? 100000.0;
    final location = preferences.getString('student_location') ?? '';
    final majors = preferences.getStringList('student_majors') ?? const [];
    return StudentProfileModel(
      grade: grade,
      yearlyBudget: budget,
      location: location,
      majors: majors,
    );
  }
}
