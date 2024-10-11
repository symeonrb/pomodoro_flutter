import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/timer_cubit.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // This timer allows the ui to refresh every 0.1 seconds,
    // in order to see the countdown
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
    final working = context.read<TimerCubit>().state?.working ?? false;

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
        appBar: AppBar(
          backgroundColor: colorScheme.inversePrimary,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TimerCubit>().clear();
            },
            icon: const Icon(Icons.close),
          ),
        ),
        backgroundColor: colorScheme.inversePrimary,
        body: ListView(
          children: [
            Center(
              // This key is necessary to force rebuilds
              child: Counter(key: UniqueKey()),
            ),
            const SizedBox(height: 60),
            Text(
              working ? 'Au boulot !' : "Une pause s'impose",
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => context
                    .read<TimerCubit>()
                    .cheat(dontWait: const Duration(minutes: -5)),
                child: const Text('-5 min'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context
                    .read<TimerCubit>()
                    .cheat(dontWait: const Duration(seconds: -10)),
                child: const Text('-10 sec'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerCubit>().state;
    if (timer == null) return const SizedBox.shrink();
    final nextStepIn = timer.nextStepIn;
    final formattedElapsed =
        '${nextStepIn.inMinutes}:${(nextStepIn.inSeconds % 60).toString().padLeft(2, '0')}';

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
          CircularProgressIndicator(
            value: nextStepIn.inSeconds /
                max(1, timer.durationOfCurrentStep.inSeconds),
            strokeWidth: 5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                Text(
                  formattedElapsed,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 10),
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                  child: timer.isRunning
                      ? IconButton(
                          onPressed: context.read<TimerCubit>().pause,
                          icon: const Icon(Icons.pause),
                        )
                      : IconButton(
                          onPressed: context.read<TimerCubit>().resume,
                          icon: const Icon(Icons.play_arrow),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
