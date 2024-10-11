// Timer States
// ignore_for_file: invalid_use_of_visible_for_testing_member

class TimerState {
  TimerState({
    required this.startedAt,
    required this.pausedAt,
    required this.workMinutes,
    required this.restMinutes,
    required this.working,
  });

  TimerState.started({required this.workMinutes, required this.restMinutes})
      : startedAt = DateTime.now(),
        pausedAt = null,
        working = true;

  final DateTime startedAt;
  final DateTime? pausedAt;
  final int workMinutes;
  final int restMinutes;
  final bool working;

  TimerState paused() => TimerState(
        startedAt: startedAt,
        pausedAt: DateTime.now(),
        workMinutes: workMinutes,
        restMinutes: restMinutes,
        working: working,
      );

  TimerState resumed() => pausedAt == null
      ? this
      : TimerState(
          startedAt: startedAt.add(DateTime.now().difference(pausedAt!)),
          pausedAt: null,
          workMinutes: workMinutes,
          restMinutes: restMinutes,
          working: working,
        );

  Duration get timeElapsed => pausedAt == null
      ? DateTime.now().difference(startedAt)
      : pausedAt!.difference(startedAt);
  Duration get timeLeft {
    final left = duration - timeElapsed;
    if (left.isNegative) return Duration.zero;
    return left;
  }

  Duration get duration =>
      Duration(minutes: working ? workMinutes : restMinutes);
  bool get isRunning => pausedAt == null;
}
