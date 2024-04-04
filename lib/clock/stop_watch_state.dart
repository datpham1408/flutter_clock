import 'package:clock_app/adapter/watch_entity.dart';

class StopWatchState {}

class StopState extends StopWatchState {}

class ResetState extends StopWatchState {}

class StartState extends StopWatchState {}

class VongState extends StopWatchState {
  final int minutes;

  VongState({required this.minutes});
}

class LoadLapTimesState extends StopWatchState {
  final List<ClockEntity> list;

  LoadLapTimesState({required this.list});
}
