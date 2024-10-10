import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/timer_cubit.dart';
import 'package:pomodoro_flutter/cubit/user_cubit.dart';
import 'package:pomodoro_flutter/model/timer_state.dart';
import 'package:pomodoro_flutter/page/timer_page.dart';
import 'package:pomodoro_flutter/service/authentication_service.dart';
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
            onPressed: () {
              context
                  .read<TimerCubit>()
                  .start(workMinutes: 45, restMinutes: 15);

              context.pushPage(const TimerPage());
            },
            child: const Text('Commencer à travailler'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: BigButton(
                  onPressed: () {
                    context
                        .read<TimerCubit>()
                        .start(workMinutes: 45, restMinutes: 15);

                    context.pushPage(const TimerPage());
                  },
                  child: const Text('45 / 15'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BigButton(
                  onPressed: () {
                    context
                        .read<TimerCubit>()
                        .start(workMinutes: 25, restMinutes: 5);

                    context.pushPage(const TimerPage());
                  },
                  child: const Text('25 / 5'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BigButton(
                  onPressed: () {
                    context
                        .read<TimerCubit>()
                        .start(workMinutes: 2, restMinutes: 1);

                    context.pushPage(const TimerPage());
                  },
                  child: const Text('2 / 1'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const HistoryCard(),
        ],
      ),
    );
  }
}

class BigButton extends StatelessWidget {
  const BigButton({required this.onPressed, required this.child, super.key});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Theme.of(context).colorScheme.primary,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: DefaultTextStyle(
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(child: child),
          ),
        ),
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
