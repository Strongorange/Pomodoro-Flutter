import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

initNotificaton() async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await notifications.initialize(initializationSettings);
}
