// Timer States
// ignore_for_file: invalid_use_of_visible_for_testing_member

class TimerState {
  TimerState({
    required this.startedAt,
    required this.pausedAt,
    required this.workMinutes,
    required this.restMinutes,
  });

  TimerState.started({required this.workMinutes, required this.restMinutes})
      : startedAt = DateTime.now(),
        pausedAt = null;

  final DateTime startedAt;
  final DateTime? pausedAt;
  final int workMinutes;
  final int restMinutes;

  TimerState paused() => TimerState(
        startedAt: startedAt,
        pausedAt: DateTime.now(),
        workMinutes: workMinutes,
        restMinutes: restMinutes,
      );

  TimerState resumed() => pausedAt == null
      ? this
      : TimerState(
          startedAt: startedAt.add(DateTime.now().difference(pausedAt!)),
          pausedAt: null,
          workMinutes: workMinutes,
          restMinutes: restMinutes,
        );

  bool get isRunning => pausedAt == null;

  Duration get timeElapsed => pausedAt == null
      ? DateTime.now().difference(startedAt)
      : pausedAt!.difference(startedAt);

  bool get working {
    final minutesElapsed = timeElapsed.inMinutes;
    final fullStepMinutes = workMinutes + restMinutes;

    final currentFullStepMinutes = minutesElapsed % fullStepMinutes;

    return currentFullStepMinutes < workMinutes;
  }

  Duration get durationOfCurrentStep =>
      Duration(minutes: working ? workMinutes : restMinutes);

  Duration get timeElapsedSinceLastStep {
    final millisecondsElapsedSinceLastWorkStart =
        timeElapsed.inMilliseconds % ((workMinutes + restMinutes) * 60 * 1000);
    if (millisecondsElapsedSinceLastWorkStart > (workMinutes * 60 * 1000)) {
      // The work step is finished
      return Duration(
        milliseconds:
            millisecondsElapsedSinceLastWorkStart - (workMinutes * 60 * 1000),
      );
    } else {
      // The work step is live
      return Duration(milliseconds: millisecondsElapsedSinceLastWorkStart);
    }
  }

  Duration get nextStepIn {
    final left = durationOfCurrentStep - timeElapsedSinceLastStep;
    if (left.isNegative) return Duration.zero;
    return left;
  }
}
