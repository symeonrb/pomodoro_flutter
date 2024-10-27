import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/session_in_progress_cubit.dart';
import 'package:pomodoro_flutter/cubit/user_cubit.dart';
import 'package:pomodoro_flutter/model/session.dart';
import 'package:pomodoro_flutter/service/database_service.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:pomodoro_flutter/widget/big_button.dart';
import 'package:pomodoro_flutter/widget/countdown_widget.dart';

class SessionInProgressPage extends StatefulWidget {
  const SessionInProgressPage({super.key});

  @override
  State<SessionInProgressPage> createState() => _SessionInProgressPageState();
}

class _SessionInProgressPageState extends State<SessionInProgressPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // This timer allows the ui to refresh every 0.1 seconds,
    // in order to see the countdown, and for the theme to change when needed.
    // We cannot replace this by a listener, since there is no data update.
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
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
              // This key is necessary to force ui rebuilds.
              child: CountdownWidget(key: UniqueKey()),
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

                    context.read<DatabaseService>().saveSession(
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

              // The following code helps to speed up a session when debugging
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
