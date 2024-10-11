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

  Workmanager().executeTask((task, inputData) async {
    log('Called background task: $task');

    if (task == 'notifyTimeToRest') {
      final frequencyMinutes = inputData?['frequencyMinutes'] as int? ?? 1;

      unawaited(
        NotificationService.instance.sendNotification(
          id: generateUidInt(),
          title: "Une pause s'impose !",
        ),
      );

      await Workmanager().registerOneOffTask(
        generateUidString(),
        'notifyTimeToRest',
        initialDelay: Duration(minutes: frequencyMinutes),
        inputData: {'frequencyMinutes': frequencyMinutes},
      );
    } else if (task == 'notifyTimeToWork') {
      final frequencyMinutes = inputData?['frequencyMinutes'] as int? ?? 1;

      unawaited(
        NotificationService.instance.sendNotification(
          id: generateUidInt(),
          title: 'Au boulot !',
        ),
      );

      await Workmanager().registerOneOffTask(
        generateUidString(),
        'notifyTimeToWork',
        initialDelay: Duration(minutes: frequencyMinutes),
        inputData: {'frequencyMinutes': frequencyMinutes},
      );
    }
    return Future.value(true);
  });
}
