import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_flutter/home/home_page.dart';
import 'package:pomodoro_flutter/service/background_service.dart';
import 'package:pomodoro_flutter/service/notification_service.dart';
import 'package:pomodoro_flutter/timer/timer_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await BackgroundService.initialize();
  await NotificationService.initialize();

  runApp(const PomodoroApp());
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
