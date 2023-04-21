import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pomodoro_flutter/providers/time_provider.dart';
import 'package:pomodoro_flutter/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  Future<void> requestPermission() async {
    final status = await Permission.notification.request();
  }

  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await requestPermission();
  await notifications.initialize(initializationSettings);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimeProvider(),
      child: MaterialApp(
        title: 'Pomodoro',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
            background: const Color(0xFFE7626C),
          ),
          textTheme: const TextTheme(
              displayLarge: TextStyle(
            color: Color(0xFF232B55),
          )),
          cardColor: const Color(0xFFF4EDDB),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
