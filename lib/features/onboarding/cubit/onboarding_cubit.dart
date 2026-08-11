import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/student_profile_model.dart';
import '../repositories/student_profile_repository.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({StudentProfileRepository? repository})
      : _repository = repository ?? StudentProfileRepository(),
        super(const OnboardingState());

  final StudentProfileRepository _repository;

  void nextStep() {
    emit(state.copyWith(stepIndex: (state.stepIndex + 1).clamp(0, 5).toInt()));
  }

  void previousStep() => emit(state.copyWith(stepIndex: (state.stepIndex - 1).clamp(0, 5).toInt()));

  void updateGrade(double value) => emit(state.copyWith(profile: state.profile.copyWith(grade: value)));
  void updateBudget(double value) => emit(state.copyWith(profile: state.profile.copyWith(yearlyBudget: value)));
  void updateLocation(String value) => emit(state.copyWith(profile: state.profile.copyWith(location: value)));
  void toggleMajor(String major) {
    final majors = [...state.profile.majors];
    majors.contains(major) ? majors.remove(major) : majors.add(major);
    emit(state.copyWith(profile: state.profile.copyWith(majors: majors)));
  }

  Future<void> completeOnboarding() async {
    await _repository.save(state.profile);
    emit(state.copyWith(isCompleted: true));
  }
}
