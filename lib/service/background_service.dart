// Mandatory if the App is obfuscated or using Flutter 3.1+
import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:pomodoro_flutter/service/notification_service.dart';
import 'package:pomodoro_flutter/utils.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }
}

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize(fromWorkmanager: true);
  final workManager = Workmanager();

  workManager.executeTask((task, inputData) async {
    log('Called background task: $task');

    if (task == 'pomodoro.notifyTimeToRest') {
      final frequencyMinutes = inputData?['frequencyMinutes'] as int? ?? 1;

      await workManager.registerOneOffTask(
        'pomodoro.notifyTimeToRest',
        'pomodoro.notifyTimeToRest',
        initialDelay: Duration(minutes: frequencyMinutes),
        inputData: {'frequencyMinutes': frequencyMinutes},
      );

      await NotificationService.instance.cancelAll();

      await NotificationService.instance.sendNotification(
        id: generateUidInt(),
        title: "Une pause s'impose !",
      );
    } else if (task == 'pomodoro.notifyTimeToWork') {
      final frequencyMinutes = inputData?['frequencyMinutes'] as int? ?? 1;

      await workManager.registerOneOffTask(
        'pomodoro.notifyTimeToWork',
        'pomodoro.notifyTimeToWork',
        initialDelay: Duration(minutes: frequencyMinutes),
        inputData: {'frequencyMinutes': frequencyMinutes},
      );

      await NotificationService.instance.cancelAll();

      await NotificationService.instance.sendNotification(
        id: generateUidInt(),
        title: 'Au boulot !',
      );
    }
    return Future.value(true);
  });
}
