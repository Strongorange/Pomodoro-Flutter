import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  int totalPomodoros = 0;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
        totalPomodoros++;
        totalSeconds = twentyFiveMinutes;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds--;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = twentyFiveMinutes;
    });
  }

  String formatIntToTime(int seconds) {
    var duration = Duration(seconds: seconds);
    var minText = (duration.toString().split(".").first.substring(2, 7));
    return minText;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  formatIntToTime(totalSeconds),
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
                        onPressed: isRunning ? onPausePressed : onStartPressed,
                        icon: Icon(isRunning
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline),
                        iconSize: 120,
                        color: Theme.of(context).cardColor),
                    isRunning
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
                              '$totalPomodoros',
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
