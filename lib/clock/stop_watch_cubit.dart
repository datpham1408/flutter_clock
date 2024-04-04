import 'dart:async';
import 'package:clock_app/clock/stop_watch_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClockCubit extends Cubit<StopWatchState> {
  bool running = false;
  bool selected = false;
  int milliseconds = 0;
  Timer? time;

  ClockCubit() : super(StopWatchState());

  void toggleStartStop({int? time}) {
    if (running) {
      stop();
      if (running) {
        loop();
      }
    } else {
      start();
      if (!running) {
        reset();
      }
    }
  }

  void loop() {
    running = true;
    emit(VongState(minutes: milliseconds));
  }

  void start() {
    running = true;
    if (time?.isActive != true) {
      time = Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
        milliseconds++;
        emit(StartState());
      });
    }
  }

  void stop() {
    running = false;
    time?.cancel();
    emit(StopState());
  }

  void reset() {
    milliseconds = 0;
    time?.cancel();
    running = false;
    emit(ResetState());
  }
}
