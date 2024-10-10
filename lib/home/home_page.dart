import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/timer/timer_cubit.dart';
import 'package:pomodoro_flutter/timer/timer_page.dart';
import 'package:pomodoro_flutter/timer/timer_state.dart';
import 'package:pomodoro_flutter/utils.dart';

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
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocSelector<TimerCubit, TimerState?, bool>(
              selector: (timer) => timer == null,
              builder: (context, noTimer) {
                if (noTimer) return const SizedBox.shrink();
                return FilledButton(
                  onPressed: () {
                    context.pushPage(const TimerPage());
                  },
                  child: const Text('Go timer page'),
                );
              },
            ),
            FilledButton(
              onPressed: () {
                context
                    .read<TimerCubit>()
                    .start(workMinutes: 45, restMinutes: 15);

                context.pushPage(const TimerPage());
              },
              child: const Text('45 / 15'),
            ),
            FilledButton(
              onPressed: () {
                context
                    .read<TimerCubit>()
                    .start(workMinutes: 25, restMinutes: 5);

                context.pushPage(const TimerPage());
              },
              child: const Text('25 / 5'),
            ),
            FilledButton(
              onPressed: () {
                context
                    .read<TimerCubit>()
                    .start(workMinutes: 2, restMinutes: 1);

                context.pushPage(const TimerPage());
              },
              child: const Text('2 / 1'),
            ),
            // SizedBox(height: 40),
            // FilledButton(
            //   onPressed: () =>
            //       NotificationService.instance.zonedScheduleNotification(),
            //   child: const Text('Test Notif'),
            // ),
          ],
        ),
      ),
    );
  }
}
