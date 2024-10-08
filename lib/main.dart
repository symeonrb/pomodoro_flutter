import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/generate_uid.dart';

void main() => runApp(const PomodoroApp());

// Timer States
class TimerState {
  TimerState.start({required this.duration})
      : startedAt = DateTime.now(),
        pausedAt = null,
        working = true;

  TimerState._({
    required this.startedAt,
    required this.pausedAt,
    required this.duration,
    required this.working,
  });

  final DateTime startedAt;
  final DateTime? pausedAt;
  final Duration duration;
  final bool working;

  TimerState paused() => TimerState._(
        startedAt: startedAt,
        pausedAt: DateTime.now(),
        duration: duration,
        working: working,
      );

  TimerState resumed() => pausedAt == null
      ? this
      : TimerState._(
          startedAt: startedAt.add(DateTime.now().difference(pausedAt!)),
          pausedAt: null,
          duration: duration,
          working: working,
        );

  Duration get timeElapsed => pausedAt == null
      ? DateTime.now().difference(startedAt)
      : pausedAt!.difference(startedAt);
  Duration get timeLeft {
    final left = duration - timeElapsed;
    if (left.isNegative) return Duration.zero;
    return left;
  }

  bool get isRunning => pausedAt == null;
}

class TimerCubit extends Cubit<TimerState?> {
  TimerCubit()
      : workMinutes = 45,
        pauseMinutes = 15,
        super(null);

  int workMinutes;
  int pauseMinutes;

  CancelableOperation<void>? completion;
  String? completionUid;

  void cancel() {
    _cancelCompletion();
    emit(null);
  }

  void pause() {
    _cancelCompletion();
    emit(state?.paused());
  }

  void resume() {
    emit(state?.resumed());
    _restartCompletion();
  }

  void start({required int workMinutes, required int pauseMinutes}) {
    this.workMinutes = workMinutes;
    this.pauseMinutes = pauseMinutes;
    emit(TimerState.start(duration: Duration(minutes: workMinutes)));
    _restartCompletion();
  }

  void _restartCompletion() {
    _cancelCompletion();
    print('restart');
    completionUid = generateUid();
    final completionUidAtOperationStart = completionUid;
    completion = CancelableOperation.fromFuture(
      Future.delayed(
        state!.timeLeft,
        () {
          if (completionUidAtOperationStart != completionUid || state == null) {
            return;
          }
          debugPrint('Timer completed function executed!');
          emit(
            TimerState._(
              startedAt: DateTime.now(),
              pausedAt: null,
              duration: Duration(
                minutes: state!.working ? pauseMinutes : workMinutes,
              ),
              working: !state!.working,
            ),
          );

          _restartCompletion();
        },
      ),
      onCancel: () => {debugPrint('onCancel')},
    );
  }

  void _cancelCompletion() {
    if (completion == null) return;
    completion!.cancel();
    completion = null;
    completionUid = null;
  }
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerCubit(),
      child: BlocSelector<TimerCubit, TimerState?, bool?>(
        selector: (timer) => timer?.working,
        builder: (context, working) {
          return MaterialApp(
            title: 'Pomodoro',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: working == null
                    ? Colors.pinkAccent
                    : working
                        ? Colors.blue
                        : Colors.orangeAccent,
              ),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TimerCubit, TimerState?, bool?>(
      selector: (timer) => timer?.isRunning,
      builder: (context, running) {
        return AnimatedContainer(
          duration: Durations.medium1,
          color: Theme.of(context).colorScheme.inversePrimary,
          child: BlocSelector<TimerCubit, TimerState?, bool>(
            selector: (timer) => timer == null,
            builder: (context, noTimer) {
              if (noTimer) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () => context.read<TimerCubit>().start(
                              workMinutes: 45,
                              pauseMinutes: 15,
                            ),
                        child: const Text('45 / 15'),
                      ),
                      FilledButton(
                        onPressed: () => context.read<TimerCubit>().start(
                              workMinutes: 25,
                              pauseMinutes: 5,
                            ),
                        child: const Text('25 / 5'),
                      ),
                      FilledButton(
                        onPressed: () => context.read<TimerCubit>().start(
                              workMinutes: 2,
                              pauseMinutes: 1,
                            ),
                        child: const Text('2 / 1'),
                      ),
                    ],
                  ),
                );
              } else {
                return const TimerScreen();
              }
            },
          ),
        );
      },
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
                    onPressed: () {
                      final timerCubit = context.read<TimerCubit>();
                      final timer = timerCubit.state;
                      if (timer == null) return;

                      timerCubit
                        ..emit(
                          TimerState._(
                            startedAt: timer.startedAt
                                .add(const Duration(minutes: -5)),
                            pausedAt: timer.pausedAt,
                            duration: timer.duration,
                            working: timer.working,
                          ),
                        )
                        .._restartCompletion();
                    },
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
                    onPressed: context.read<TimerCubit>().cancel,
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      final timerCubit = context.read<TimerCubit>();
                      final timer = timerCubit.state;
                      if (timer == null) return;

                      timerCubit
                        ..emit(
                          TimerState._(
                            startedAt: timer.startedAt
                                .add(const Duration(seconds: -10)),
                            pausedAt: timer.pausedAt,
                            duration: timer.duration,
                            working: timer.working,
                          ),
                        )
                        .._restartCompletion();
                    },
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
    final timerState = context.watch<TimerCubit>().state!;
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
