// Mandatory if the App is obfuscated or using Flutter 3.1+
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_flutter/service/notification_service.dart';
import 'package:pomodoro_flutter/cubit/timer_cubit.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }
}

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await NotificationService.initialize(fromWorkmanager: true);

  Workmanager().executeTask((task, inputData) async {
    log('Called background task: $task');
    if (task == 'timerEnd') await TimerCubit.instance.onTimerEnd();
    return Future.value(true);
  });
}
