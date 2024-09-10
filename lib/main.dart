import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/features/controllers/doctorListController.dart';
import 'package:psychiatrist_project/features/controllers/doctor_profile_controller.dart';
import 'package:psychiatrist_project/features/doctorScreen/screens/Splash.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/ReminderController.dart';
import 'package:psychiatrist_project/size_confige.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(DocProfileController());
  Get.put(AuthController());
  Get.put(DoctorController());
  Get.put(ReminderController());
  // Initialize notification
  // tz.initializeTimeZones(); // Initialize time zones
  // String timeZone =
  //     await FlutterNativeTimezone.getLocalTimezone(); // Get the local timezone
  // tz.setLocalLocation(tz.getLocation(timeZone));
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (context) {
        SizeConfig.initSize(context);
        return Splash();
      }),
    );
  }
}
