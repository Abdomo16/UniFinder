import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/locale_cubit.dart';
import '../../l10n/l10n.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => context.read<LocaleCubit>().toggle(),
      icon: const Icon(Icons.language),
      label: Text(AppLocalizations.of(context).language),
    );
  }
}
