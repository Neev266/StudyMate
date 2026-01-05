import 'package:flutter_app/features/Game/bloc/game_event.dart';
import 'package:flutter_app/features/Game/bloc/game_state.dart';
import 'package:flutter_app/features/Game/data/game_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BoredBloc extends Bloc<BoredEvent, BoredState> {
  final BoredRepository repository;

  BoredBloc(this.repository) : super(BoredInitial()) {
    on<FetchBoredActivity>((event, emit) async {
      emit(BoredLoading());
      try {
        final activity = await repository.fetchActivity();
        emit(BoredLoaded(activity));
      } catch (e) {
        emit(BoredError('Something went wrong'));
      }
    });
  }
}
