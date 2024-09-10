import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psychiatrist_project/features/auth/signInScreen.dart';
import 'package:psychiatrist_project/features/controllers/doctor_profile_controller.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/doctor_app.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/doctor_app.dart';
import 'package:psychiatrist_project/features/patientScreen/screens/SurveyQuestions/survey_question.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<DateTime> blackoutDates = <DateTime>[].obs; // Appointment Screen Variable
  // var userName = "".obs;
  var nameAsAPatient = "".obs;
  var nameAsADoctor = "".obs;
  RxBool isPatient = false.obs;
  RxBool isDoctor = false.obs;
  RxBool isLoading = false.obs;
  RxBool isObscure = true.obs;
  FirebaseAuth get auth => _auth;
   String currentUserId = '';
  String currentUserName = 'Patient Name';

  DocProfileController _docProfileController = Get.find<DocProfileController>();

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
      isLoading.value = true;
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
          'mon': 0,
          'tue': 0,
          'wed': 0,
          'thurs': 0,
          'fri': 0,
          'sat': 0,
          'sun': 0
        });
        isDoctor.value = true;
        Get.to(SignInPage(), arguments: {'role': role.value});
        Get.snackbar(
          "Message",
          "Sin Up Successfully $fullName",
          duration: Duration(seconds: 5), // Optional: Set snackbar duration
        );
      } else {
        await _firestore.collection('patientList').doc(userId).set({
          'fullName': fullName.value,
          'password': password.value,
          'email': email.value,
          'role': role.value,
          'firstLogin': false
        });
        isDoctor.value = false;
        Get.to(SignInPage(), arguments: {'role': role.value});
        Get.snackbar(
          "Message",
          "Sin Up Successfully $fullName",
          duration: Duration(seconds: 5), // Optional: Set snackbar duration
        );
      }
      fullName.value = "";
      email.value = "";
      password.value = "";
      specialization.value = "";
      licenseNumber.value = "";
      address.value = "";
      uniName.value = "";
      yearsOfExperience.value = "";
      role.value = "";
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Message",
        "$e",
        duration: Duration(seconds: 5), // Optional: Set snackbar duration
      );
    }
    isLoading.value = false;
  }

  Future<void> signIn() async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      fetchUserName(); // Code add by Ashher
      String userId = userCredential.user!.uid;
      _docProfileController.getDays(userId);


      DocumentSnapshot doctorDoc = await _firestore.collection('doctorList').doc(userId).get();
      DocumentSnapshot patientData = await _firestore.collection('patientList').doc(userId).get();

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
        if(patientData.exists)
          {
            if(patientData.get("firstLogin") == true)
              {
                Get.to(PatientScreen());
              }
            else{
              Get.to(DepressionSurvey());
            }
          }

      }
      email.value = '';
      password.value = '';
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Message",
        "$e",
        duration: Duration(seconds: 5), // Optional: Set snackbar duration
      );
    }
    isLoading.value = false;
  }


  void fetchUserName() async {
    if (kDebugMode) {
      print("fetchUserName called");
    }
    try {
      User? user = _auth.currentUser;
      if(user != null)
        {
          currentUserId = user.uid;

          if (isDoctor.value == false) {
            String userId = user.uid;
            final userDoc = await _firestore.collection('patientList').doc(userId).get();
            nameAsAPatient.value = userDoc['fullName'] ?? "Anonymous";
          }
          else if (isDoctor.value == true) {
            String userId = user.uid;
            final userDoc = await _firestore.collection('doctorList').doc(userId).get();
            nameAsADoctor.value = userDoc['fullName'] ?? "Anonymous";
          }

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
