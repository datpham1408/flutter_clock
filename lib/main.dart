import 'package:clock_app/clock/stop_watch_cubit.dart';
import 'package:clock_app/router/my_application.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  await initGetIt();
  await initCubit();
  runApp(const Application());
}

Future<void> initGetIt() async {}

Future<void> initCubit() async {
  getIt.registerLazySingleton<ClockCubit>(() => ClockCubit());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyApplication(),
    );
  }
}
