import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/app_router.dart';
import 'core/constants/app_colors.dart';
import 'core/cubit/locale_cubit.dart';
import 'core/cubit/locale_state.dart';
import 'l10n/l10n.dart';

class UniFinderApp extends StatelessWidget {
  const UniFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit()..load(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) => MaterialApp.router(
          title: 'UniFinder',
          locale: localeState.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: AppRouter.router,
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              primaryContainer: AppColors.primaryContainer,
              onPrimaryContainer: AppColors.onPrimaryContainer,
              secondary: AppColors.secondary,
              onSecondary: AppColors.onSecondary,
              secondaryContainer: AppColors.secondaryContainer,
              onSecondaryContainer: AppColors.onSecondaryContainer,
              error: AppColors.error,
              onError: AppColors.onError,
              errorContainer: AppColors.errorContainer,
              onErrorContainer: AppColors.onErrorContainer,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
              surfaceContainerHighest: AppColors.surfaceVariant,
              onSurfaceVariant: AppColors.onSurfaceVariant,
              outline: AppColors.outline,
              outlineVariant: AppColors.outlineVariant,
            ),
            scaffoldBackgroundColor: AppColors.surface,
            useMaterial3: true,
            fontFamily: 'Inter',
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
