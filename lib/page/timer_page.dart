import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/session_in_progress_cubit.dart';
import 'package:pomodoro_flutter/cubit/user_cubit.dart';
import 'package:pomodoro_flutter/model/session.dart';
import 'package:pomodoro_flutter/service/session_service.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:pomodoro_flutter/widget/big_button.dart';

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
    final working =
        context.read<SessionInProgressCubit>().state?.working ?? false;

    return Theme(
      data: PomodoroTheme.get(working: working),
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Center(
              // This key is necessary to force rebuilds
              child: Counter(key: UniqueKey()),
            ),
            const SizedBox(height: 60),
            Center(
              child: Image.asset(
                working ? 'assets/work.png' : 'assets/rest.png',
                width: 128,
                height: 128,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              working ? 'Au boulot !' : "Une pause s'impose",
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BigButton(
                onPressed: () {
                  final userId = context.read<UserCubit>().state?.uid;
                  if (userId != null) {
                    // Save session
                    final session =
                        context.read<SessionInProgressCubit>().state;
                    if (session == null) return;

                    context.read<SessionService>().saveSession(
                          session: Session(
                            id: generateUidString(length: 20),
                            userId: userId,
                            startedAt: session.startedAt,
                            endedAt: DateTime.now(),
                            workMinutes: session.workMinutes,
                            restMinutes: session.restMinutes,
                          ),
                        );
                  }

                  context.read<SessionInProgressCubit>().finishSession();
                  Navigator.of(context).pop();
                },
                child: const Text('Terminer la session'),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     TextButton(
              //       onPressed: () => context
              //           .read<SessionInProgressCubit>()
              //           .cheat(dontWait: const Duration(minutes: -5)),
              //       child: const Text('-5 min'),
              //     ),
              //     const SizedBox(height: 20),
              //     TextButton(
              //       onPressed: () => context
              //           .read<SessionInProgressCubit>()
              //           .cheat(dontWait: const Duration(seconds: -10)),
              //       child: const Text('-10 sec'),
              //     ),
              //   ],
              // ),
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
    final timer = context.watch<SessionInProgressCubit>().state;
    if (timer == null) return const SizedBox.shrink();
    final nextStepIn = timer.nextStepIn;
    final formattedElapsed = '${nextStepIn.inMinutes}:'
        '${(nextStepIn.inSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      width: 150,
      height: 150,
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
                const SizedBox(height: 20),
                Text(
                  formattedElapsed,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                // const SizedBox(height: 10),
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                  child: timer.isRunning
                      ? IconButton(
                          onPressed:
                              context.read<SessionInProgressCubit>().pause,
                          icon: const Icon(Icons.pause),
                        )
                      : IconButton(
                          onPressed:
                              context.read<SessionInProgressCubit>().resume,
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
