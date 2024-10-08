import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/timer/timer_cubit.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({
    required this.workMinutes,
    required this.pauseMinutes,
    super.key,
  });

  final int workMinutes;
  final int pauseMinutes;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerCubit(
        TimerState.start(duration: Duration(minutes: workMinutes)),
        workMinutes: workMinutes,
        pauseMinutes: pauseMinutes,
      ),
      child: BlocSelector<TimerCubit, TimerState, bool>(
        selector: (timer) => timer.working,
        builder: (context, working) {
          final colorScheme = ColorScheme.fromSeed(
            seedColor: working ? Colors.blue : Colors.orangeAccent,
          );

          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: working ? Colors.blue : Colors.orangeAccent,
              ),
              useMaterial3: true,
            ),
            child: Scaffold(
              backgroundColor: colorScheme.inversePrimary,
              body: const TimerScreen(),
            ),
          );
        },
      ),
    );
  }
}

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        const Counter(),
        const SizedBox(height: 20),
        IconTheme(
          data: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
            size: 40,
          ),
          child: BlocSelector<TimerCubit, TimerState?, bool>(
            selector: (timer) => timer?.isRunning ?? false,
            builder: (context, isRunning) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context
                        .read<TimerCubit>()
                        .cheat(dontWait: const Duration(minutes: -5)),
                    child: const Text('+5 min'),
                  ),
                  const SizedBox(height: 20),
                  if (isRunning)
                    IconButton(
                      onPressed: context.read<TimerCubit>().pause,
                      icon: const Icon(Icons.pause),
                    )
                  else
                    IconButton(
                      onPressed: context.read<TimerCubit>().resume,
                      icon: const Icon(Icons.play_arrow),
                    ),
                  const SizedBox(width: 40),
                  IconButton(
                    onPressed: () {
                      context.read<TimerCubit>().cancel();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context
                        .read<TimerCubit>()
                        .cheat(dontWait: const Duration(seconds: -10)),
                    child: const Text('+10 sec'),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        BlocSelector<TimerCubit, TimerState?, bool>(
          selector: (timer) => timer?.working ?? true,
          builder: (context, working) {
            return Text(
              working ? 'Au boulot !' : "Une pause s'impose",
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            );
          },
        ),
      ],
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<TimerCubit>().state;
    final elapsed = timerState.timeLeft;
    final formattedElapsed =
        '${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Text(
              formattedElapsed,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          CircularProgressIndicator(
            value: elapsed.inSeconds / timerState.duration.inSeconds,
            strokeWidth: 5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ],
      ),
    );
  }
}
