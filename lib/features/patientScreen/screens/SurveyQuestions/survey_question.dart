import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/doctor_app.dart';
import 'package:psychiatrist_project/features/patientScreen/screens/SurveyQuestions/model/question_mode.dart';

class DepressionSurveyController extends GetxController {
  final List<SurveyQuestion> surveyQuestions = [
    SurveyQuestion(
      question: "Your date of birth?",
      options: ["Under 12", "Teenager", "Adult"],
      weight: 5,
    ),
    SurveyQuestion(
      question: "Are you sleeping enough?",
      options: ["Yes", "No"],
      weight: 5,
    ),
    SurveyQuestion(
      question: "Do you engage in physical activities? Or Do you exercise?",
      options: ["Yes", "No"],
      weight: 10,
    ),
    SurveyQuestion(
      question: "Do you have a phobia?",
      options: ["Yes", "No"],
      weight: 5,
    ),
    SurveyQuestion(
      question: "Do you take any medication?",
      options: ["Yes", "No"],
      weight: 15,
    ),
    SurveyQuestion(
      question: "Do you intake drugs?",
      options: ["Yes", "No"],
      weight: 10,
    ),
    SurveyQuestion(
      question: "Do you often skip meals?",
      options: ["Yes", "No"],
      weight: 15,
    ),
    SurveyQuestion(
      question: "Do you take sleeping pills?",
      options: ["Yes", "No"],
      weight: 10,
    ),
    SurveyQuestion(
      question: "Do you often lose your senses and get injured?",
      options: ["Yes", "No"],
      weight: 25,
    ),
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double calculateDepressionPercentage() {
    int totalWeight = surveyQuestions.fold(0, (sum, question) => sum + question.weight);
    int userScore = 0;

    for (var question in surveyQuestions) {
      if (question.selectedOption.isNotEmpty) {
        userScore += question.weight;
      }
    }

    double percentage = (userScore / totalWeight) * 100;
    return percentage;
  }

  Future<void> saveToFirebase() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;
        final firestore = FirebaseFirestore.instance;
        final userDoc = await firestore.collection('patientList').doc(userId).get();
        String userName = userDoc['fullName'] ?? "Anonymous";

        double depressionPercentage = calculateDepressionPercentage();

        await _firestore.collection('patientSurveyReport').doc(userId).set({
          'user_id': userId,
          'user_name': userName,
          'depression_percentage': depressionPercentage,
          'survey_date': DateTime.now(),
          'answers': surveyQuestions
              .map((q) => {
                    'question': q.question,
                    'selected_option': q.selectedOption,
                  })
              .toList(),
        });

        Get.snackbar(
          'Success',
          'Your report has been saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'User not logged in!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save report: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void showResult() {
    double percentage = calculateDepressionPercentage();
    String resultMessage;

    if (percentage < 20) {
      resultMessage = "You have a low chance of depression symptoms (${percentage.toStringAsFixed(1)}%).";
    } else if (percentage < 50) {
      resultMessage = "You may have moderate chances of depression symptoms (${percentage.toStringAsFixed(1)}%).";
    } else {
      resultMessage = "You have a high chance of depression symptoms (${percentage.toStringAsFixed(1)}%).";
    }

    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Depression Level",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              resultMessage,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                  percentage > 50 ? Colors.red : Colors.green),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.blueAccent,
            ),
            onPressed: () {
              String userId = FirebaseAuth.instance.currentUser!.uid;
              saveToFirebase().whenComplete(() {
                FirebaseFirestore.instance.collection('patientList').doc(userId).update(
                    {
                      "firstLogin": true
                    });
                Get.to(PatientScreen());
              },);
            },
            child: Text(
              "Go to Home",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class DepressionSurvey extends StatelessWidget {
  final DepressionSurveyController controller =
      Get.put(DepressionSurveyController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Depression Survey"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: controller.surveyQuestions.length,
            itemBuilder: (context, index) {
              final question = controller.surveyQuestions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: question.selectedOption.isEmpty
                              ? null
                              : question.selectedOption,
                          items: question.options
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            question.selectedOption = value!;
                            log(question.selectedOption);
                            controller.update();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          hint: Text("Select an option"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bool hasEmptySelectedOption = controller.surveyQuestions.any((question) => question.selectedOption.isEmpty);

            log("hasEmptySelectedOption: ${hasEmptySelectedOption}");
            if(!hasEmptySelectedOption)
              {
                controller.showResult();
              }
            else{
              Get.showSnackbar(GetSnackBar(title: 'Alert', message: "Fill Form Completely", duration: Duration(seconds: 2),));
            }
            
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.check),
          tooltip: "Calculate Depression Level",
        ),
      ),
    );
  }
}
