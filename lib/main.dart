import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/Patient/controllers/authController.dart';
import 'package:psychiatrist_project/Patient/controllers/doctorListController.dart';
import 'package:psychiatrist_project/Patient/patientScreen/screens/Home.dart';
import 'package:psychiatrist_project/Patient/patientScreen/screens/Splash.dart';
import 'package:psychiatrist_project/Patient/patientScreen/presentation/doctor_app.dart';
import 'package:psychiatrist_project/size_confige.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  Get.put(DoctorController());
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

