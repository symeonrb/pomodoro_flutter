import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro_flutter/cubit/timer_cubit.dart';
import 'package:pomodoro_flutter/cubit/user_cubit.dart';
import 'package:pomodoro_flutter/firebase_options.dart';
import 'package:pomodoro_flutter/page/home_page.dart';
import 'package:pomodoro_flutter/service/authentication_service.dart';
import 'package:pomodoro_flutter/service/background_service.dart';
import 'package:pomodoro_flutter/service/notification_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await BackgroundService.initialize();
  await NotificationService.initialize();

  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.pinkAccent);

    return RepositoryProvider(
      create: (context) => AuthenticationService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: TimerCubit.instance),
          BlocProvider(create: (context) => UserCubit()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Pomodoro',
          theme: ThemeData(
            colorScheme: colorScheme,
            useMaterial3: true,
            cardTheme: const CardTheme(margin: EdgeInsets.zero),
            scaffoldBackgroundColor: colorScheme.inversePrimary,
            appBarTheme:
                AppBarTheme(backgroundColor: colorScheme.inversePrimary),
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
