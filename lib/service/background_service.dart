// Mandatory if the App is obfuscated or using Flutter 3.1+
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
      await NotificationService.instance.sendNotification(
        id: generateUid(),
        title: "Une pause s'impose !",
      );
    } else if (task == 'notifyTimeToWork') {
      await NotificationService.instance.sendNotification(
        id: generateUid(),
        title: 'Au boulot !',
      );
    }
    return Future.value(true);
  });
}
