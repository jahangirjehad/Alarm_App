import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  List<Map<String, dynamic>> _alarms = [];
  DateTime? _selectedTime;

  Future<void> initialize() async {
    const settings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(InitializationSettings(android: settings));

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestExactAlarmsPermission();
  }
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request exact alarm permission
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleNotification(DateTime time) async {
    debugPrint('Input time: ${time.toString()}');
    if (time.isBefore(DateTime.now())) {
      time = time.add(const Duration(days: 1));
      debugPrint('Adjusted time (past): ${time.toString()}');
    }
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(time, tz.local);
    debugPrint('Scheduling alarm for: ${scheduledTime.toString()}');

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'This channel is used for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Alarm',
        'Time to wake up!',
        notificationDetails,
      );
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Use a unique ID (e.g., based on db id) to avoid overwriting
        'Alarm',
        'Time to wake up!',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Notification scheduled successfully for ${scheduledTime.toString()}');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      if (e.toString().contains('exact_alarms_not_permitted')) {
        debugPrint('Falling back to inexact scheduling');
        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Alarm',
          'Time to wake up!',
          scheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        debugPrint('Inexact notification scheduled for ${scheduledTime.toString()}');
      }
    }
  }
}
