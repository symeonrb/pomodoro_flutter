import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/cubit/history_cubit.dart';
import 'package:pomodoro_flutter/cubit/user_cubit.dart';
import 'package:pomodoro_flutter/model/session.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    if (user == null) return const SizedBox.shrink();

    return BlocBuilder<HistoryCubit, Iterable<Session>>(
      builder: (context, sessions) {
        if (sessions.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historique',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: sessions.map(SessionTile.new).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SessionTile extends StatelessWidget {
  const SessionTile(this.session, {super.key});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(session.id),
    );
  }
}
