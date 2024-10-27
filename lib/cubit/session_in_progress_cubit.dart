// Timer States
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_flutter/model/session_in_grogress.dart';
import 'package:pomodoro_flutter/service/notification_service.dart';

/// This cubit holds the session that isn't completed yet.
class SessionInProgressCubit extends Cubit<SessionInProgress?> {
  SessionInProgressCubit() : super(null);

  Future<void> _restartTimer({bool fromCompletion = false}) async {
    if (!fromCompletion) await _cancelTimer();

    if (state == null) return;

    final working = state!.working;
    var nextStepIn = state!.nextStepIn;

    // Schedule every notification for the next 24 hours
    while (nextStepIn.inHours < 24) {
      unawaited(
        NotificationService.instance.scheduleNotification(
          title: 'Au boulot !',
          showIn: working
              ? nextStepIn + Duration(minutes: state!.restMinutes)
              : nextStepIn,
        ),
      );

      unawaited(
        NotificationService.instance.scheduleNotification(
          title: "Une pause s'impose !",
          showIn: working
              ? nextStepIn
              : nextStepIn + Duration(minutes: state!.workMinutes),
        ),
      );

      nextStepIn = nextStepIn +
          Duration(minutes: state!.workMinutes + state!.restMinutes);
    }
  }

  Future<void> _cancelTimer() => NotificationService.instance.cancelAll();

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
      SessionInProgress(
        workMinutes: workMinutes,
        restMinutes: restMinutes,
        startedAt: DateTime.now(),
        pausedAt: null,
      ),
    );
    _restartTimer();
  }

  void cheat({required Duration dontWait}) {
    if (state == null) return;
    emit(
      SessionInProgress(
        startedAt: state!.startedAt.add(dontWait),
        pausedAt: state!.pausedAt,
        workMinutes: state!.workMinutes,
        restMinutes: state!.restMinutes,
      ),
    );
    _restartTimer();
  }
}
