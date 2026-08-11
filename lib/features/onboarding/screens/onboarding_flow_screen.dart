import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/language_toggle.dart';
import '../../../l10n/l10n.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/hero_image_section.dart';
import '../widgets/onboarding_bottom_actions.dart';
import '../widgets/onboarding_eyebrow_chip.dart';
import '../widgets/onboarding_input_card.dart';
import '../widgets/step_budget_slider.dart';
import '../widgets/step_grade_input.dart';
import '../widgets/step_location_picker.dart';
import '../widgets/step_major_selector.dart';
import 'onboarding_summary_screen.dart';

class OnboardingFlowScreen extends StatelessWidget {
  const OnboardingFlowScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => OnboardingCubit(),
    child: const _OnboardingView(),
  );
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  static const _stepCount = 6;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) =>
          !previous.isCompleted && current.isCompleted,
      listener: (context, state) => context.go('/discover'),
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final cubit = context.read<OnboardingCubit>();
        final isWelcome = state.stepIndex == 0;
        final isSummary = state.stepIndex == _stepCount - 1;
        final content = _contentFor(state, cubit);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: state.stepIndex == 0
                ? null
                : IconButton(
                    tooltip: l10n.back,
                    onPressed: cubit.previousStep,
                    icon: const Icon(Icons.arrow_back),
                  ),
            actions: const [
              Padding(
                padding: EdgeInsetsDirectional.only(end: 8),
                child: LanguageToggle(),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Center(
                        child: Column(
                          children: [
                            if (isWelcome) ...[
                              OnboardingEyebrowChip(text: l10n.welcomeEyebrow),
                              const SizedBox(height: 20),
                            ],
                            if (!isSummary) ...[
                              Text(
                                _titleFor(l10n, state.stepIndex),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _bodyFor(l10n, state.stepIndex),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 32),
                            ],
                            content,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                OnboardingBottomActions(
                  currentStep: state.stepIndex,
                  stepCount: _stepCount,
                  isSummary: isSummary,
                  buttonLabel: isSummary
                      ? l10n.finish
                      : isWelcome
                      ? l10n.start
                      : l10n.next,
                  onPressed: isSummary
                      ? cubit.completeOnboarding
                      : cubit.nextStep,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _contentFor(OnboardingState state, OnboardingCubit cubit) =>
      switch (state.stepIndex) {
        0 => const HeroImageSection(),
        1 => OnboardingInputCard(
          child: StepGradeInput(
            value: state.profile.grade,
            onChanged: cubit.updateGrade,
          ),
        ),
        2 => OnboardingInputCard(
          child: StepBudgetSlider(
            value: state.profile.yearlyBudget,
            onChanged: cubit.updateBudget,
          ),
        ),
        3 => OnboardingInputCard(
          child: StepLocationPicker(
            value: state.profile.location,
            onChanged: cubit.updateLocation,
          ),
        ),
        4 => StepMajorSelector(
          selected: state.profile.majors,
          onToggle: cubit.toggleMajor,
        ),
        _ => OnboardingSummaryScreen(profile: state.profile),
      };

  String _titleFor(AppLocalizations l10n, int step) => [
    l10n.welcomeTitle,
    l10n.stepGradeTitle,
    l10n.stepBudgetTitle,
    l10n.stepLocationTitle,
    l10n.stepMajorTitle,
    l10n.summaryTitle,
  ][step];

  String _bodyFor(AppLocalizations l10n, int step) => [
    l10n.welcomeBody,
    l10n.stepGradeBody,
    l10n.stepBudgetBody,
    l10n.stepLocationBody,
    l10n.stepMajorBody,
    l10n.summaryBody,
  ][step];
}
