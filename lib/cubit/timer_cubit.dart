// Timer States
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/model/timer_state.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:workmanager/workmanager.dart';

class TimerCubit extends Cubit<TimerState?> {
  TimerCubit() : super(null);

  Future<void> _restartTimer({bool fromCompletion = false}) async {
    if (!fromCompletion) await _cancelTimer();

    if (state == null) return;

    final working = state!.working;
    final nextStepIn = state!.nextStepIn;

    await Workmanager().registerOneOffTask(
      generateUidString(),
      'notifyTimeToWork',
      initialDelay: working
          ? nextStepIn + Duration(minutes: state!.restMinutes)
          : nextStepIn,
      inputData: {'frequencyMinutes': state!.workMinutes + state!.restMinutes},
    );

    await Workmanager().registerOneOffTask(
      generateUidString(),
      'notifyTimeToRest',
      initialDelay: working
          ? nextStepIn
          : nextStepIn + Duration(minutes: state!.workMinutes),
      inputData: {'frequencyMinutes': state!.workMinutes + state!.restMinutes},
    );
  }

  Future<void> _cancelTimer() => Workmanager().cancelAll();

  Future<void> finishSession() async {
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

  void startSession({required int workMinutes, required int restMinutes}) {
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
