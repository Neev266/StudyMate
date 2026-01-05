

import 'package:flutter_app/features/Game/data/game_model.dart';

abstract class BoredState {}

class BoredInitial extends BoredState {}

class BoredLoading extends BoredState {}

class BoredLoaded extends BoredState {
  final BoredActivity activity;
  BoredLoaded(this.activity);
}

class BoredError extends BoredState {
  final String message;
  BoredError(this.message);
}
