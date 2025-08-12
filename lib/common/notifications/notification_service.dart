import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    if (Platform.isAndroid) {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
      await androidImpl?.createNotificationChannel(const AndroidNotificationChannel(
        'conquests',
        'Conquest Reminders',
        description: 'Summons to remind you of tasks',
        importance: Importance.high,
      ));
    }
  }

  Future<int> scheduleAt({
    required String title,
    required String body,
    required DateTime when,
  }) async {
    final id = when.millisecondsSinceEpoch.remainder(1 << 31);
    final androidDetails = AndroidNotificationDetails(
      'conquests',
      'Conquest Reminders',
      channelDescription: 'Summons to remind you of tasks',
      importance: Importance.high,
      priority: Priority.high,
    );
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      NotificationDetails(android: androidDetails),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
    return id;
  }

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
