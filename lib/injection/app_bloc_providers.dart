import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/fit_score/cubit/fit_score_cubit.dart';

class AppBlocProviders {
  static List<BlocProvider> get providers => [
        BlocProvider<FitScoreCubit>(
          create: (BuildContext context) => FitScoreCubit(),
        ),
      ];
}
