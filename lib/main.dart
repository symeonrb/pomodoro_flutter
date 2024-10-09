import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/home/home_page.dart';
import 'package:pomodoro_flutter/service/notification_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Show notif with sound controlled by alarm volume
  // TODO: Show notif with chronometer
  await NotificationService.init();

  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Pomodoro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
