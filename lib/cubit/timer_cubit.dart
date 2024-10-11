// Timer States
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_flutter/model/timer_state.dart';
import 'package:pomodoro_flutter/service/notification_service.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:workmanager/workmanager.dart';

class TimerCubit extends HydratedCubit<TimerState?> {
  TimerCubit._() : super(null);

  @override
  TimerState? fromJson(Map<dynamic, dynamic>? json) => json == null
      ? null
      : TimerState(
          startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ??
              DateTime.now(),
          pausedAt: DateTime.tryParse(json['pausedAt'] as String? ?? ''),
          workMinutes: json['workMinutes'] as int? ?? 0,
          restMinutes: json['restMinutes'] as int? ?? 0,
          working: json['working'] as bool? ?? true,
        );

  @override
  Map<String, dynamic>? toJson(TimerState? state) => state == null
      ? null
      : {
          'startedAt': state.startedAt.toIso8601String(),
          'pausedAt': state.pausedAt?.toIso8601String(),
          'workMinutes': state.workMinutes,
          'restMinutes': state.restMinutes,
          'working': state.working,
        };

  static final instance = TimerCubit._();

  Future<void> _restartTimer({bool fromCompletion = false}) async {
    if (!fromCompletion) await _cancelTimer();

    if (state == null) return;

    await Workmanager().registerOneOffTask(
      state!.working ? 'workTimer' : 'restTimer',
      'timerEnd',
      initialDelay: state!.timeLeft,
    );
  }

  Future<void> _cancelTimer() async {
    await Workmanager().cancelByUniqueName('workTimer');
    await Workmanager().cancelByUniqueName('restTimer');
  }

  @override
  Future<void> clear() async {
    await _cancelTimer();
    emit(null);
    await super.clear();
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

  Future<void> checkBackgroundUpdate() async {
    try {
      final storage = await HydratedStorageX.getRefreshed(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getApplicationDocumentsDirectory(),
      );

      final stateJson = storage.read(storageToken) as Map<dynamic, dynamic>?;
      final timer = fromJson(stateJson);
      if (timer != null && timer.working != state?.working) {
        emit(timer);
      }
    } catch (error, stackTrace) {
      onError(error, stackTrace);
    }
  }

  void cheat({required Duration dontWait}) {
    if (state == null) return;
    emit(
      TimerState(
        startedAt: state!.startedAt.add(dontWait),
        pausedAt: state!.pausedAt,
        workMinutes: state!.workMinutes,
        restMinutes: state!.restMinutes,
        working: state!.working,
      ),
    );
    _restartTimer();
  }

  /// Called by background
  Future<void> onTimerEnd() async {
    if (state == null) return;
    final wasWorking = state!.working;

    try {
      await NotificationService.instance.sendNotification(
        id: generateUid(),
        title: wasWorking ? "Une pause s'impose !" : 'Au boulot !',
      );
      emit(
        TimerState(
          startedAt: DateTime.now(),
          pausedAt: null,
          workMinutes: state!.workMinutes,
          restMinutes: state!.restMinutes,
          working: !wasWorking,
        ),
      );

      try {
        final stateJson = toJson(state);
        if (stateJson != null) {
          await HydratedBloc.storage
              .write(storageToken, stateJson)
              .then((_) {}, onError: print);
        }
      } catch (error) {
        log(error.toString());
        if (error is StorageNotFound) rethrow;
      }

      await _restartTimer(fromCompletion: true);
      await Workmanager().cancelByUniqueName(
        wasWorking ? 'workTimer' : 'restTimer',
      );
    } catch (e) {
      log(e.toString());
    }
  }
}

extension HydratedStorageX on HydratedStorage {
  static Future<HydratedStorage> getRefreshed({
    required Directory storageDirectory,
    HydratedCipher? encryptionCipher,
  }) async {
    // Close old storage
    await HydratedStorage.hive.close();

    // Read current storage
    Box<dynamic> box;
    if (storageDirectory == HydratedStorage.webStorageDirectory) {
      box = await HydratedStorage.hive.openBox(
        'hydrated_box',
        encryptionCipher: encryptionCipher,
      );
    } else {
      HydratedStorage.hive.init(storageDirectory.path);
      box = await HydratedStorage.hive.openBox(
        'hydrated_box',
        encryptionCipher: encryptionCipher,
      );
    }

    return HydratedStorage(box);
  }
}
