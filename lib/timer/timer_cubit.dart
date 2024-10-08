// Timer States
import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/utils.dart';

class TimerState {
  TimerState.start({required this.duration})
      : startedAt = DateTime.now(),
        pausedAt = null,
        working = true;

  TimerState._({
    required this.startedAt,
    required this.pausedAt,
    required this.duration,
    required this.working,
  });

  final DateTime startedAt;
  final DateTime? pausedAt;
  final Duration duration;
  final bool working;

  TimerState paused() => TimerState._(
        startedAt: startedAt,
        pausedAt: DateTime.now(),
        duration: duration,
        working: working,
      );

  TimerState resumed() => pausedAt == null
      ? this
      : TimerState._(
          startedAt: startedAt.add(DateTime.now().difference(pausedAt!)),
          pausedAt: null,
          duration: duration,
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

  bool get isRunning => pausedAt == null;
}

class TimerCubit extends Cubit<TimerState> {
  TimerCubit(
    super.initialState, {
    required this.workMinutes,
    required this.pauseMinutes,
  });

  int workMinutes;
  int pauseMinutes;

  CancelableOperation<void>? completion;
  String? completionUid;

  @override
  Future<void> close() {
    _cancelCompletion();
    return super.close();
  }

  void cancel() {
    _cancelCompletion();
  }

  void pause() {
    _cancelCompletion();
    emit(state.paused());
  }

  void resume() {
    emit(state.resumed());
    _restartCompletion();
  }

  void start({required int workMinutes, required int pauseMinutes}) {
    this.workMinutes = workMinutes;
    this.pauseMinutes = pauseMinutes;
    emit(TimerState.start(duration: Duration(minutes: workMinutes)));
    _restartCompletion();
  }

  void _restartCompletion() {
    _cancelCompletion();
    completionUid = generateUid();
    final completionUidAtOperationStart = completionUid;
    completion = CancelableOperation.fromFuture(
      Future.delayed(
        state.timeLeft,
        () {
          if (completionUidAtOperationStart != completionUid) {
            return;
          }

          emit(
            TimerState._(
              startedAt: DateTime.now(),
              pausedAt: null,
              duration: Duration(
                minutes: state.working ? pauseMinutes : workMinutes,
              ),
              working: !state.working,
            ),
          );
          _restartCompletion();
        },
      ),
    );
  }

  void _cancelCompletion() {
    if (completion == null) return;
    completion!.cancel();
    completion = null;
    completionUid = null;
  }

  void cheat({required Duration dontWait}) {
    emit(
      TimerState._(
        startedAt: state.startedAt.add(dontWait),
        pausedAt: state.pausedAt,
        duration: state.duration,
        working: state.working,
      ),
    );
    _restartCompletion();
  }
}
