import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/timer_cubit.dart';
import 'package:pomodoro_flutter/page/timer_page.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:pomodoro_flutter/widget/history_section.dart';
import 'package:pomodoro_flutter/widget/session_section.dart';
import 'package:pomodoro_flutter/widget/user_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<TimerCubit>().state != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        context.pushPage(const TimerPage());
      });
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 100),
          UserSection(),
          SizedBox(height: 60),
          SessionSection(),
          SizedBox(height: 40),
          HistorySection(),
        ],
      ),
    );
  }
}
