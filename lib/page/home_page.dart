import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/timer_cubit.dart';
import 'package:pomodoro_flutter/cubit/user_cubit.dart';
import 'package:pomodoro_flutter/main.dart';
import 'package:pomodoro_flutter/model/rythm.dart';
import 'package:pomodoro_flutter/model/timer_state.dart';
import 'package:pomodoro_flutter/page/select_rythm_page.dart';
import 'package:pomodoro_flutter/page/timer_page.dart';
import 'package:pomodoro_flutter/service/authentication_service.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:pomodoro_flutter/widget/big_button.dart';

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
        children: [
          const SizedBox(height: 100),
          const UserCard(),
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
          const SizedBox(height: 60),
          BigButton(
            onPressed: () async {
              final timerCubit = context.read<TimerCubit>();

              final rythm =
                  await context.pushPage<Rythm>(const SelectRythmPage());

              if (rythm == null) return;

              timerCubit.startSession(
                workMinutes: rythm.workMinutes,
                restMinutes: rythm.restMinutes,
              );

              await navigatorKey.currentContext?.pushPage(const TimerPage());
            },
            child: Column(
              children: [
                // Icon(Icons.mindf),
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/1672/1672248.png',
                  width: 64,
                ),
                const SizedBox(height: 10),
                const Text('Commencer à travailler'),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const HistoryCard(),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;

    if (user == null) {
      return Card(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: FilledButton(
          onPressed: () {
            context.read<AuthenticationService>().signInWithGoogle();
          },
          child: const Text('Se connecter avec Google'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Bonjour',
                  ),
                  Text(
                    user.displayName ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            if (user.photoURL != null) ...[
              const SizedBox(width: 20),
              CircleAvatar(
                foregroundImage: NetworkImage(user.photoURL!),
                radius: 30,
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: context.read<AuthenticationService>().signOut,
            child: const Text('Déconnexion'),
          ),
        ),
      ],
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    if (user == null) return const SizedBox.shrink();

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Historique',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
