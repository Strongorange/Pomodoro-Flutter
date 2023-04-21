import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_flutter/providers/time_provider.dart';
import 'package:pomodoro_flutter/screens/setting_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  /// Scaffold의 상태를 관리하는 키입니다.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer timer;
  bool isAppInBackground = false;

  /// 상태창 알림을 위한 아이디입니다.
  final int notificationId = 100;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> _updateNotification(String timeText) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'silent_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.low, // Importance를 low로 설정합니다.
      priority: Priority.low, // Priority를 low로 설정합니다.
      showWhen: false,
      playSound: false, // playSound 속성을 false로 설정합니다.
      visibility: NotificationVisibility.secret,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'Pomodoro Timer',
      '남은 시간: $timeText', // 남은 시간을 표시합니다.
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

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
    if (isAppInBackground) {
      _updateNotification(formatIntToTime(timeProvider.totalSecondsValue));
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
      timeProvider.setTotalSeconds(timeProvider.twentyFiveMinutesValue);
    });
  }

  /// 초를 분:초 형태로 변환하는 함수입니다.
  String formatIntToTime(int seconds) {
    var duration = Duration(seconds: seconds);
    var minText = (duration.toString().split(".").first.substring(2, 7));
    return minText;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// 위젯 제거시 타이머를 제거합니다.
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        isAppInBackground = false;
        _cancelNotification();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        isAppInBackground = true;
        _updateNotification(formatIntToTime(
            Provider.of<TimeProvider>(context, listen: false)
                .totalSecondsValue));
        break;
    }
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
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            ListTile(
              title: const Text(
                '설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
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
