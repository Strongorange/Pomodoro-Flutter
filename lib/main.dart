import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/screens/home_screen.dart';
import 'package:pomodoro_flutter/screens/setting_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingScreen(),
      },
      initialRoute: '/',
    );
  }
}
