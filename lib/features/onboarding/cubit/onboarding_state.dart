part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  final int stepIndex;
  final bool isCompleted;
  final StudentProfileModel profile;

  const OnboardingState({
    this.stepIndex = 0,
    this.isCompleted = false,
    this.profile = const StudentProfileModel(),
  });

  OnboardingState copyWith({
    int? stepIndex,
    bool? isCompleted,
    StudentProfileModel? profile,
  }) {
    return OnboardingState(
      stepIndex: stepIndex ?? this.stepIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [stepIndex, isCompleted, profile.grade, profile.yearlyBudget, profile.location, profile.majors];
}
