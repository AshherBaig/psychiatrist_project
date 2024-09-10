import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;

class ReminderController extends GetxController {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var reminders = [].obs;

  @override
  void onInit() {
    super.onInit();
    tzData.initializeTimeZones(); // Initialize timezones
    initializeNotifications();
    loadReminders();
  }

  // Initialize local notifications
  void initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Load reminders from SharedPreferences
  void loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedReminders = prefs.getStringList('reminders');
    if (savedReminders != null) {
      reminders.assignAll(savedReminders);
    }
  }

  // Save reminders to SharedPreferences
  void saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'reminders', reminders.map((r) => r.toString()).toList());
  }

  // Add a reminder and schedule a notification
  void addReminder(String type, String time) {
    reminders.add('$type at $time');
    saveReminders();
    scheduleNotification(type, time);
  }

  // Convert DateTime to TZDateTime
  tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    final tzLocation = tz.local; // Use device's local timezone
    return tz.TZDateTime.from(dateTime, tzLocation);
  }

  // Schedule a notification
  void scheduleNotification(String type, String time) async {
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'This is a reminder notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformDetails = NotificationDetails(android: androidDetails);

    // Parse the time for scheduling
    DateTime reminderTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(time);

    // Check if the reminder time is in the past, adjust it if necessary
    DateTime now = DateTime.now();
    if (reminderTime.isBefore(now)) {
      // If it's in the past, adjust it to the next day
      reminderTime = reminderTime.add(Duration(days: 1));
    }

    // Convert to TZDateTime
    tz.TZDateTime tzReminderTime = _convertToTZDateTime(reminderTime);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder: $type',
      'It\'s time for your $type',
      tzReminderTime,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
