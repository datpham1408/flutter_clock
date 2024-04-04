import 'package:clock_app/clock/stop_watch_cubit.dart';
import 'package:clock_app/clock/stop_watch_state.dart';
import 'package:clock_app/model/loop_model.dart';
import 'package:clock_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  final ClockCubit _clockCubit = getIt.get<ClockCubit>();
  bool? running;
  List<LoopModel> listLoopModel = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: SafeArea(
        child: BlocProvider<ClockCubit>(
          create: (_) => _clockCubit,
          child: BlocConsumer<ClockCubit, StopWatchState>(
            listener: (_, StopWatchState state) {
              _handleListener(state);
            },
            builder: (_, StopWatchState state) {
              //context
              return Container(
                child: itemBody(),
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget itemBody() {
    return Column(children: [
      Expanded(flex: 3, child: itemTimes()),
      Expanded(
        flex: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                itemLoopAndReset(),
                itemStartAndStop(),
              ]),
        ),
      ),
      Container(margin: const EdgeInsets.all(16), child: divider()),
      Expanded(flex: 5, child: itemListTime())
    ]);
  }

  Widget divider() {
    return const Divider(
      thickness: 0.3,
      color: Colors.grey,
    );
  }

  Widget itemListTime() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listLoopModel.length,
      itemBuilder: (context, index) {
        final LoopModel loopModel = listLoopModel[index];
        return itemDetailListTime(time: loopModel.time, title: loopModel.title);
      },
    );
  }

  int getShortestLoopTime() {
    if (listLoopModel.isEmpty) {
      return 0;
    }

    String shortestTimeString = listLoopModel[0].time;
    int shortestTime = convertStringTimeToMillisecond(shortestTimeString);

    for (int i = 1; i < listLoopModel.length; i++) {
      String currentTimeString = listLoopModel[i].time;
      int currentTime = convertStringTimeToMillisecond(currentTimeString);

      if (currentTime < shortestTime) {
        shortestTime = currentTime;
      }
    }

    return shortestTime;
  }

  int getLongestLoopTime() {
    if (listLoopModel.isEmpty) {
      return 0;
    }

    String longestTimeString = listLoopModel[0].time;
    int longestTime = convertStringTimeToMillisecond(longestTimeString);

    for (int i = 1; i < listLoopModel.length; i++) {
      String currentTimeString = listLoopModel[i].time;
      int currentTime = convertStringTimeToMillisecond(currentTimeString);

      if (currentTime > longestTime) {
        longestTime = currentTime;
      }
    }

    return longestTime;
  }

  Widget itemDetailListTime({String? title, String? time}) {
    Color textColor = Colors.white;
    int convertTime = convertStringTimeToMillisecond(time ?? '');
    if (convertTime == getShortestLoopTime()) {
      textColor = Colors.green;
    } else if (convertTime == getLongestLoopTime()) {
      textColor = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title ?? '',
                style: TextStyle(color: textColor),
              ),
              Text(
                time ?? '',
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          divider(),
        ],
      ),
    );
  }

  Widget itemLoopAndReset() {
    return BlocBuilder<ClockCubit, StopWatchState>(
      builder: (_, StopWatchState state) {
        if (state is StartState) {
          return GestureDetector(
              onTap: () {
                _clockCubit.loop();
              },
              //loop
              child: itemButton(
                colorBackground: Colors.grey.withOpacity(0.5),
                colorText: Colors.grey,
                text: 'Loop',
              ));
        }
        return GestureDetector(
            onTap: () {
              _clockCubit.reset();
            },
            child: itemButton(
              colorBackground: Colors.grey.withOpacity(0.5),
              colorText: Colors.grey,
              text: 'Reset',
            ));
      },
    );
  }

  Widget itemStartAndStop() {
    return BlocBuilder<ClockCubit, StopWatchState>(
      builder: (_, StopWatchState state) {
        if (state is StartState) {
          return GestureDetector(
              onTap: () {
                _clockCubit.toggleStartStop();
              },
              child: itemButton(
                  colorBackground: Colors.red.withOpacity(0.5),
                  colorText: Colors.red,
                  text: 'Stop'));
        }
        return GestureDetector(
            onTap: () {
              _clockCubit.toggleStartStop();
            },
            child: itemButton(
                colorBackground: Colors.green.withOpacity(0.5),
                colorText: Colors.green,
                text: 'Start'));
      },
    );
  }

  Widget itemTimes() {
    return Align(
      alignment: const Alignment(0, 0.5),
      child: BlocBuilder<ClockCubit, StopWatchState>(
        builder: (_, StopWatchState state) {
          return Text(
            formatMilliseconds(_clockCubit.milliseconds),
            style: const TextStyle(fontSize: 48, color: Colors.white),
          );
        },
      ),
    );
  }

  Widget itemButton({Color? colorBackground, Color? colorText, String? text}) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(360),
        color: colorBackground,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text ?? '',
          style: TextStyle(color: colorText, fontSize: 20),
        ),
      ),
    );
  }

  String formatMilliseconds(int milliseconds) {
    int minutes = (milliseconds / (1000 * 60)).floor();
    int seconds = (milliseconds / 1000).floor() % 60;
    int millis = (milliseconds % 1000) ~/ 10;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    String millisStr = millis.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr,$millisStr';
  }

  int convertStringTimeToMillisecond(String time) {
    List<String> data = time.split(':');
    int minutes = int.parse(data[0]);

    data = data[1].split(',');
    int second = int.parse(data[0]);
    int millisecond = int.parse(data[1]);

    int result = (minutes * 60 * 1000) + (second * 1000) + millisecond;

    return result;
  }

  String calculatorTime(String time, int minutes) {
    int millisecond = convertStringTimeToMillisecond(time);

    int result = minutes - millisecond;
    String total = formatMilliseconds(result);
    return total;
  }

  void _handleListener(StopWatchState state) {
    if (state is VongState) {
      final loops = listLoopModel.length;
      final LoopModel data = LoopModel(
        title: 'Vong ${loops + 1}',
        time: formatMilliseconds(state.minutes),
      );
      if (loops >= 1) {
        int totalTime = 0;
        for (int i = 0; i < listLoopModel.length; i++) {
          int timeIndex = convertStringTimeToMillisecond(listLoopModel[i].time);
          totalTime += timeIndex;
        }
        int timeNow = state.minutes;
        int result = timeNow - totalTime;
        data.time = formatMilliseconds(result);
      }
      listLoopModel.add(data);
    }
    if (state is ResetState) {
      listLoopModel.clear();
    }
    if (state is StartState) {}
    if (state is StopState) {}
  }
}
