import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/user_cubit.dart';
import 'package:pomodoro_flutter/service/authentication_service.dart';

class UserSection extends StatelessWidget {
  const UserSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;

    if (user == null) {
      return Card(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: InkWell(
          onTap: () => context.read<AuthenticationService>().signInWithGoogle(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  'assets/google.png',
                  width: 40,
                ),
                const SizedBox(width: 16),
                Text(
                  'Se connecter avec Google',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
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
