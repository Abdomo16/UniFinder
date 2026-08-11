import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(Locale('en')));

  static const _key = 'locale_code';

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString(_key);
    if (code == 'ar' || code == 'en') emit(LocaleState(Locale(code!)));
  }

  Future<void> toggle() =>
      setLocale(state.locale.languageCode == 'ar' ? 'en' : 'ar');

  Future<void> setLocale(String code) async {
    if (code != 'ar' && code != 'en') return;
    final locale = Locale(code);
    emit(LocaleState(locale));
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, code);
  }
}
