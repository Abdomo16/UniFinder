import 'package:flutter/widgets.dart';

/// Lightweight localized copy for the two languages supported by UniFinder.
class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  String get appName => isArabic ? 'يوني فايندر' : 'UniFinder';
  String get welcomeEyebrow =>
      isArabic ? 'خطوتك الأولى نحو الجامعة' : 'Your path to university starts here';
  String get welcomeTitle =>
      isArabic ? 'اعثر على جامعتك المثالية' : 'Find your perfect university';
  String get welcomeBody => isArabic
      ? 'أخبرنا بما يهمك، وسنقترح لك الجامعات المناسبة.'
      : 'Tell us what matters to you and we will recommend the right universities.';
  String get start => isArabic ? 'ابدأ الآن' : 'Get started';
  String get next => isArabic ? 'التالي' : 'Next';
  String get back => isArabic ? 'رجوع' : 'Back';
  String get finish => isArabic ? 'عرض نتائجي' : 'Show my matches';
  String get skip => isArabic ? 'تخطي الآن' : 'Skip for now';
  String get stepGradeTitle => isArabic ? 'ما هي درجتك؟' : 'What is your grade?';
  String get stepGradeBody => isArabic
      ? 'استخدم النسبة الحالية أو المتوقعة. يمكنك تعديلها لاحقاً.'
      : 'Use your current or expected percentage. You can change it later.';
  String get stepBudgetTitle => isArabic ? 'ما ميزانيتك السنوية؟' : 'What is your yearly budget?';
  String get stepBudgetBody => isArabic
      ? 'سنستخدمها لإظهار الخيارات التي تناسب خطتك المالية.'
      : 'We will use it to surface options that fit your financial plan.';
  String get stepLocationTitle => isArabic ? 'أين تفضّل الدراسة؟' : 'Where would you like to study?';
  String get stepLocationBody => isArabic
      ? 'اختر مدينة أو منطقة، وسنرتب الجامعات الأقرب أولاً.'
      : 'Choose a city or region and we will prioritize nearby universities.';
  String get stepMajorTitle => isArabic ? 'ما التخصص الذي يهمك؟' : 'What would you like to study?';
  String get stepMajorBody => isArabic
      ? 'اختر تخصصاً واحداً على الأقل لنقدم لك تطابقات أدق.'
      : 'Choose at least one field to give you more accurate matches.';
  String get gradeLabel => isArabic ? 'النسبة المئوية' : 'Percentage';
  String get budgetLabel => isArabic ? 'ميزانية سنوية' : 'Yearly budget';
  String get locationHint => isArabic ? 'مثال: القاهرة، مصر' : 'For example: Cairo, Egypt';
  String get locationLabel => isArabic ? 'المدينة أو المنطقة' : 'City or region';
  String get selectAtLeastOne => isArabic ? 'اختر تخصصاً واحداً على الأقل' : 'Select at least one major';
  String get summaryTitle => isArabic ? 'لقد أصبحنا جاهزين!' : 'You are all set!';
  String get summaryBody => isArabic
      ? 'سنستخدم تفضيلاتك لإيجاد أفضل الجامعات لك.'
      : 'We will use your preferences to find your best university matches.';
  String get language => isArabic ? 'English' : 'العربية';
  String get selectedMajors => isArabic ? 'التخصصات المختارة' : 'Selected majors';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((item) => item.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
