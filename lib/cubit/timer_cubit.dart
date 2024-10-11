// Timer States
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/model/timer_state.dart';
import 'package:workmanager/workmanager.dart';

class TimerCubit extends Cubit<TimerState?> {
  TimerCubit._() : super(null);

  static final instance = TimerCubit._();

  Future<void> _restartTimer({bool fromCompletion = false}) async {
    if (!fromCompletion) await _cancelTimer();

    if (state == null) return;

    final frequency =
        Duration(minutes: state!.workMinutes + state!.restMinutes);
    final working = state!.working;
    final nextStepIn = state!.nextStepIn;

    await Workmanager().registerPeriodicTask(
      'notifyTimeToWork',
      'notifyTimeToWork',
      frequency: frequency,
      initialDelay: working
          ? nextStepIn + Duration(minutes: state!.restMinutes)
          : nextStepIn,
    );

    await Workmanager().registerPeriodicTask(
      'notifyTimeToRest',
      'notifyTimeToRest',
      frequency: frequency,
      initialDelay: working
          ? nextStepIn
          : nextStepIn + Duration(minutes: state!.workMinutes),
    );
  }

  Future<void> _cancelTimer() async {
    await Workmanager().cancelByUniqueName('notifyTimeToWork');
    await Workmanager().cancelByUniqueName('notifyTimeToRest');
  }

  Future<void> clear() async {
    emit(null);
    await _cancelTimer();
  }

  void pause() {
    if (state == null) return;
    emit(state!.paused());
    _cancelTimer();
  }

  void resume() {
    if (state == null) return;
    emit(state!.resumed());
    _restartTimer();
  }

  void start({required int workMinutes, required int restMinutes}) {
    emit(
      TimerState.started(workMinutes: workMinutes, restMinutes: restMinutes),
    );
    _restartTimer();
  }

  void cheat({required Duration dontWait}) {
    if (state == null) return;
    emit(
      TimerState(
        startedAt: state!.startedAt.add(dontWait),
        pausedAt: state!.pausedAt,
        workMinutes: state!.workMinutes,
        restMinutes: state!.restMinutes,
      ),
    );
    _restartTimer();
  }
}
