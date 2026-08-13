import 'package:flutter/foundation.dart';
import '../models/fit_score_result_model.dart';

@immutable
abstract class FitScoreState {
  const FitScoreState();
}

class FitScoreInitial extends FitScoreState {
  const FitScoreInitial();
}

class FitScoreCalculating extends FitScoreState {
  const FitScoreCalculating();
}

class FitScoreCalculated extends FitScoreState {
  final FitScoreResultModel result;

  const FitScoreCalculated(this.result);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitScoreCalculated &&
          runtimeType == other.runtimeType &&
          result == other.result;

  @override
  int get hashCode => result.hashCode;
}

class FitScoreError extends FitScoreState {
  final String message;

  const FitScoreError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitScoreError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
