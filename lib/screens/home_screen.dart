import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_flutter/providers/time_provider.dart';
import 'package:pomodoro_flutter/screens/setting_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  /// Scaffold의 상태를 관리하는 키입니다.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// FIXME: Provider 의 값 사용하는 작업 완료 후 제거
  static const twentyFiveMinutes = 1500;
  static int totalSeconds = twentyFiveMinutes;
  late Timer timer;

  void onTick(Timer timer) {
    final timeProvider = Provider.of<TimeProvider>(context, listen: false);
    if (timeProvider.totalSecondsValue == 0) {
      setState(() {
        timeProvider.setIsRunning(false);
        timeProvider.incrementPomodoros();
        timeProvider.setTotalSeconds(timeProvider.twentyFiveMinutesValue);
      });
      timer.cancel();
    } else {
      setState(() {
        timeProvider.setTotalSeconds(timeProvider.totalSecondsValue - 1);
      });
    }
  }

  /// 타이머 시작 함수입니다.
  void onStartPressed() {
    final timeProvider = Provider.of<TimeProvider>(context, listen: false);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      timeProvider.setIsRunning(true);
    });
  }

  /// 타이머 일시정지 함수입니다.
  void onPausePressed() {
    final timeProvider = Provider.of<TimeProvider>(context, listen: false);
    timer.cancel();
    setState(() {
      timeProvider.setIsRunning(false);
    });
  }

  /// 타이머 초기화 함수입니다.
  void onResetPressed() {
    final timeProvider = Provider.of<TimeProvider>(context, listen: false);
    timer.cancel();
    setState(() {
      timeProvider.setIsRunning(false);
      timeProvider.setTotalSeconds(twentyFiveMinutes);
    });
  }

  /// 초를 분:초 형태로 변환하는 함수입니다.
  String formatIntToTime(int seconds) {
    var duration = Duration(seconds: seconds);
    var minText = (duration.toString().split(".").first.substring(2, 7));
    return minText;
  }

  /// 위젯 제거시 타이머를 제거합니다.
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeProvider = Provider.of<TimeProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              /// Scaffold의 상태를 관리하는 키를 통해 Drawer를 엽니다.
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(children: [
            AppBar(
              title: const Icon(
                Icons.cancel_sharp,
                color: Colors.black,
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            ListTile(
              title: const Text('wow'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SettingScreen();
                    },
                  ),
                );
              },
            ),
          ]),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  formatIntToTime(timeProvider.totalSecondsValue),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: timeProvider.isRunningValue
                            ? onPausePressed
                            : onStartPressed,
                        icon: Icon(timeProvider.isRunningValue
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline),
                        iconSize: 120,
                        color: Theme.of(context).cardColor),
                    timeProvider.isRunningValue
                        ? SizedBox(
                            height: 30,
                            child: IconButton(
                              onPressed: onResetPressed,
                              icon: const Icon(
                                  Icons.settings_backup_restore_outlined),
                              color: Theme.of(context).cardColor,
                            ),
                          )
                        : Container(
                            height: 30,
                          ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pomodoros',
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${timeProvider.totalPomodorosValue}',
                              style: TextStyle(
                                fontSize: 58,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
