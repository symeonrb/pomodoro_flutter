import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_flutter/home/home_page.dart';
import 'package:pomodoro_flutter/service/notification_service.dart';
import 'package:pomodoro_flutter/timer/timer_cubit.dart';
import 'package:workmanager/workmanager.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await Workmanager().initialize(
    // The top level function, aka callbackDispatcher
    callbackDispatcher,
    // If enabled it will post a notification whenever the task is running.
    // Handy for debugging tasks
    // isInDebugMode: true,
  );

  // TODO: Show notif with sound controlled by alarm volume
  // TODO: Show notif with chronometer
  await NotificationService.initialize();

  runApp(const PomodoroApp());
}

// Mandatory if the App is obfuscated or using Flutter 3.1+
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
    print('Called background task: $task');
    if (task == 'timerEnd') await TimerCubit.instance.onTimerEnd();
    return Future.value(true);
  });
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TimerCubit.instance,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Pomodoro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
