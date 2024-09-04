import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  int calculateDepressionLevel() {
    int totalScore = 0;

    for (var question in surveyQuestions) {
      if (question.selectedOption.isNotEmpty) {
        // Add the weight to the total score
        totalScore += question.weight;
      }
    }

    return totalScore;
  }

  Future<void> saveToFirebase() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;
        final firestore = FirebaseFirestore.instance;
        final userDoc =
            await firestore.collection('patientList').doc(userId).get();
        String userName = userDoc['fullName'] ?? "Anonymous";

        int score = calculateDepressionLevel();

        await _firestore.collection('patientSurveyReport').doc(userId).set({
          'user_id': userId,
          'user_name': userName,
          'score': score,
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
        );
      } else {
        Get.snackbar(
          'Error',
          'User not logged in!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save report: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showResult() {
    int score = calculateDepressionLevel();
    String result;

    if (score < 20) {
      result = "Low Depression";
    } else if (score < 50) {
      result = "Moderate Depression";
    } else {
      result = "High Depression";
    }

    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          title: Text("Depression Level"),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Get.to(PatientScreen());
                saveToFirebase(); // Save to Firebase after showing the result
              },
              child: Text("Home"),
            ),
          ],
        ));
  }
}

class DepressionSurvey extends StatelessWidget {
  final DepressionSurveyController controller =
      Get.put(DepressionSurveyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Depression Survey")),
      body: ListView.builder(
        itemCount: controller.surveyQuestions.length,
        itemBuilder: (context, index) {
          final question = controller.surveyQuestions[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                    controller.update();
                  },
                  hint: Text("Select an option"),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.showResult,
        child: Icon(Icons.check),
        tooltip: "Calculate Depression Level",
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(home: DepressionSurvey()));
}
