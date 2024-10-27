import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/session_in_progress_cubit.dart';
import 'package:pomodoro_flutter/main.dart';
import 'package:pomodoro_flutter/model/rythm.dart';
import 'package:pomodoro_flutter/page/select_rythm_page.dart';
import 'package:pomodoro_flutter/page/session_in_progress_page.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:pomodoro_flutter/widget/big_button.dart';

class SessionInProgressSection extends StatefulWidget {
  const SessionInProgressSection({super.key});

  @override
  State<SessionInProgressSection> createState() =>
      _SessionInProgressSectionState();
}

class _SessionInProgressSectionState extends State<SessionInProgressSection> {
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
    final working = context.read<SessionInProgressCubit>().state?.working;

    if (working == null) {
      return BigButton(
        onPressed: () async {
          final sessionInProgressCubit = context.read<SessionInProgressCubit>();

          final rythm = await context.pushPage<Rythm>(const SelectRythmPage());

          if (rythm == null) return;

          sessionInProgressCubit.startSession(
            workMinutes: rythm.workMinutes,
            restMinutes: rythm.restMinutes,
          );

          await navigatorKey.currentContext
              ?.pushPage(const SessionInProgressPage());
        },
        child: Column(
          children: [
            Image.asset(
              'assets/work.png',
              width: 64,
            ),
            const SizedBox(height: 10),
            const Text('Commencer à travailler'),
          ],
        ),
      );
    }

    return BigButton(
      onPressed: () => context.pushPage(const SessionInProgressPage()),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  working ? 'assets/work.png' : 'assets/rest.png',
                  width: 64,
                ),
                const SizedBox(height: 10),
                if (working)
                  const Text('Au boulot !')
                else
                  const Text("Une pause s'impose !"),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}
