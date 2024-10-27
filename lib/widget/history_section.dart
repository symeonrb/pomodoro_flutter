import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_flutter/cubit/history_cubit.dart';
import 'package:pomodoro_flutter/cubit/user_cubit.dart';
import 'package:pomodoro_flutter/model/session.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    if (user == null) return const SizedBox.shrink();

    return BlocBuilder<HistoryCubit, List<Session>>(
      builder: (context, sessions) {
        if (sessions.isEmpty) return const SizedBox.shrink();

        final mappedSessions = <DateTime, List<Session>>{};
        for (final session in sessions) {
          if (mappedSessions.containsKey(session.day)) {
            mappedSessions[session.day]!.add(session);
          } else {
            mappedSessions[session.day] = [session];
          }
        }
        final mappedSessionsEntries = mappedSessions.entries.toList();

        return Column(
          children: mappedSessionsEntries
              .map(
                (entry) => SessionsDayTile(
                  day: entry.key,
                  sessions: entry.value,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class SessionsDayTile extends StatelessWidget {
  const SessionsDayTile({required this.day, required this.sessions, super.key});

  final DateTime day;
  final List<Session> sessions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('d MMMM y').format(day),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        ...(sessions..sort((a, b) => b.startedAt.compareTo(a.startedAt)))
            .map(SessionTile.new),
        const SizedBox(height: 8),
      ],
    );
  }
}

class SessionTile extends StatelessWidget {
  const SessionTile(this.session, {super.key});

  final Session session;

  @override
  Widget build(BuildContext context) {
    final total = session.endedAt.difference(session.startedAt);
    final hours = total.inHours > 0 ? '${total.inHours}h' : '';
    final minutes = total.inMinutes > 0
        ? '${(total.inMinutes % 60).toString().padLeft(2, '0')}'
            '${total.inHours > 0 ? '' : 'm'}'
        : '';
    final seconds = total.inMinutes > 0
        ? ''
        : '${(total.inSeconds % 60).toString().padLeft(2, '0')}s';
    final totalFormatted = hours + minutes + seconds;

    return IntrinsicHeight(
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 0,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${session.workMinutes}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.blue),
                    ),
                    Text(
                      ' / ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '${session.restMinutes}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.orangeAccent),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    totalFormatted,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sync),
                    const SizedBox(width: 4),
                    Text(
                      '${session.fullSteps}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
