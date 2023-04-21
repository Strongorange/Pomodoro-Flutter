import 'package:flutter/material.dart';

class TimeProvider extends ChangeNotifier {
  final int _twentyFiveMinutesValue = 1500;
  int _totalSeconds = 1500;
  bool _isRunning = false;
  int _totalPomodoros = 0;

  int get totalSecondsValue => _totalSeconds;
  int get twentyFiveMinutesValue => _twentyFiveMinutesValue;
  bool get isRunningValue => _isRunning;
  int get totalPomodorosValue => _totalPomodoros;

  void setTotalSeconds(int seconds) {
    _totalSeconds = seconds;
    notifyListeners();
  }

  void setIsRunning(bool running) {
    _isRunning = running;
    notifyListeners();
  }

  void incrementPomodoros() {
    _totalPomodoros++;
    notifyListeners();
  }
}
