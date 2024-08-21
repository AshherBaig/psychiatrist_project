import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psychiatrist_project/Patient/auth/signInScreen.dart';
import 'package:psychiatrist_project/Patient/doctorScreen/Dashboard/dashboard.dart';
import 'package:psychiatrist_project/Patient/patientScreen/screens/SurveyQuestions/survey_question.dart';
import 'package:psychiatrist_project/Patient/patientScreen/presentation/doctor_app.dart';
import 'package:psychiatrist_project/widgets/custom_snack_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userName = "".obs;
  @override
  void onInit() {
    super.onInit();
    print("UserName HomeController initialized");
    fetchUserName();
  }

  var role = ''.obs;
  var fullName = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var specialization = ''.obs;
  var certificate = ''.obs;
  var licenseNumber = ''.obs;
  var yearsOfExperience = ''.obs;
  var uniName = ''.obs;
  var address = ''.obs;

  Future<void> SignUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      String userId = userCredential.user!.uid;
      if (role.value == 'Doctor') {
        await _firestore.collection('doctorList').doc(userId).set({
          'fullName': fullName.value,
          'email': email.value,
          'password': password.value,
          'specialization': specialization.value,
          'licenseNumber': licenseNumber.value,
          'uniName': uniName.value,
          'address': address.value,
          'yearsOfExperience': yearsOfExperience.value,
          'role': role.value,
        });
        Get.snackbar(
          "Message",
          "SinUp Successfully $fullName",
          duration: Duration(seconds: 5), // Optional: Set snackbar duration
        );
      } else {
        await _firestore.collection('patientList').doc(userId).set({
          'fullName': fullName.value,
          'password': password.value,
          'email': email.value,
          'role': role.value,
        });
        Get.snackbar(
          "Message",
          "SinUp Successfully $fullName",
          duration: Duration(seconds: 5), // Optional: Set snackbar duration
        );
      }
    } catch (e) {
      Get.snackbar(
        "Message",
        "$e",
        duration: Duration(seconds: 5), // Optional: Set snackbar duration
      );
    }
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      String userId = userCredential.user!.uid;

      DocumentSnapshot doctorDoc =
          await _firestore.collection('doctorList').doc(userId).get();

      if (doctorDoc.exists) {
        Get.snackbar(
          "Message",
          "SinIn Successfully $fullName",
          duration: Duration(seconds: 5), // Optional: Set snackbar duration
        );
        // Navigate to the Doctor's screen
        Get.to(DashboardScreen());
      } else {
        Get.snackbar(
          "Message",
          "SinIn Successfully $fullName",
          duration: Duration(seconds: 5), // Optional: Set snackbar duration
        );
        // Navigate to the Patient's screen
        Get.to(DepressionSurvey());
      }
    } catch (e) {
      Get.snackbar(
        "Message",
        "$e",
        duration: Duration(seconds: 5), // Optional: Set snackbar duration
      );
    }
  }

  void fetchUserName() async {
    print("fetchUserName called");
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print("User is logged in: ${user.uid}");
        String userId = user.uid;
        final userDoc =
            await _firestore.collection('patientList').doc(userId).get();
        userName.value = userDoc['fullName'] ?? "Anonymous";
        print("Fetched userName: ${userName.value}");
      } else {
        print("No user logged in");
        userName.value = "Guest";
      }
    } catch (e) {
      print("Error fetching user data: $e");
      userName.value = "Error";
    }
  }

}
