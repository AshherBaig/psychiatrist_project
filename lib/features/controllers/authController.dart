import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/doctor_app.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/doctor_app.dart';
import 'package:psychiatrist_project/features/patientScreen/screens/SurveyQuestions/survey_question.dart';

import 'package:psychiatrist_project/widgets/custom_snack_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // var userName = "".obs;
  var nameAsAPatient = "".obs;
  var nameAsADoctor = "".obs;
  FirebaseAuth get auth => _auth;
   String currentUserId = 'patientUserId'; // Replace with actual patient user ID
  String currentUserName = 'Patient Name';


  @override
  void onInit() {
    super.onInit();
    print("UserName HomeController initialized");
    fetchUserName();
  }

  var isDoctor = false.obs;
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
      fetchUserName(); // Code add by Ashher
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
        Get.to(DoctorDashboardScreen());
      } else {
        Get.snackbar(
          "Message",
          "SinIn Successfully $fullName",
          duration: Duration(seconds: 5), // Optional: Set snackbar duration
        );
        // Navigate to the Patient's screen
        Get.to(DepressionSurvey());
        // Get.to(DoctorDashboardScreen());
        // Get.to(DoctorScreen());
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
      if (user != null && isDoctor.value == false) {
        print("User is logged in: ${user.uid}");
        String userId = user.uid;
        final userDoc = await _firestore.collection('patientList').doc(userId).get();
        nameAsAPatient.value = userDoc['fullName'] ?? "Anonymous";
        print("Fetched userName: ${nameAsAPatient.value}");
      }
      else if (user != null && isDoctor.value == true) {
        print("User is logged in: ${user.uid}");
        String userId = user.uid;
        final userDoc = await _firestore.collection('doctorList').doc(userId).get();
        nameAsADoctor.value = userDoc['fullName'] ?? "Anonymous";
        print("Fetched userName: ${nameAsADoctor.value}");
      }

      else {
        print("No user logged in");
        nameAsAPatient.value = "Guest Patient";
        nameAsADoctor.value = "Guest Patient";
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // nameAsAPatient.value = "Error";
    }
  }

  // Fetch user details by user ID
  Future<Map<String, dynamic>> getUserById(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    return doc.data() as Map<String, dynamic>;
  }

}
