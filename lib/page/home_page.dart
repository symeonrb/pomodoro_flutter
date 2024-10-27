import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/session_in_progress_cubit.dart';
import 'package:pomodoro_flutter/page/session_in_progress_page.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:pomodoro_flutter/widget/history_section.dart';
import 'package:pomodoro_flutter/widget/session_in_progress_section.dart';
import 'package:pomodoro_flutter/widget/user_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // This callback allows the app to instantly open the SessionInProgressPage
    // if a session is in progress.
    if (context.read<SessionInProgressCubit>().state != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        context.pushPage(const SessionInProgressPage());
      });
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 100),
          UserSection(),
          SizedBox(height: 60),
          SessionInProgressSection(),
          SizedBox(height: 60),
          HistorySection(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
