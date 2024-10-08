import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/timer/timer_page.dart';
import 'package:pomodoro_flutter/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () => context.pushPage(
                const TimerPage(
                  workMinutes: 45,
                  pauseMinutes: 15,
                ),
              ),
              child: const Text('45 / 15'),
            ),
            FilledButton(
              onPressed: () => context.pushPage(
                const TimerPage(
                  workMinutes: 25,
                  pauseMinutes: 5,
                ),
              ),
              child: const Text('25 / 5'),
            ),
            FilledButton(
              onPressed: () => context.pushPage(
                const TimerPage(
                  workMinutes: 2,
                  pauseMinutes: 1,
                ),
              ),
              child: const Text('2 / 1'),
            ),
          ],
        ),
      ),
    );
  }
}
