import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/features/doctorScreen/screens/selectScreen.dart';
import 'package:psychiatrist_project/res/lists.dart';
import 'package:psychiatrist_project/widgets/custom_widgets.dart';
import 'package:psychiatrist_project/widgets/text_widget.dart';

class PatientProfile extends StatefulWidget {
  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  var animate = false;
  var opacity = 0.0;
  late Size size;
  Map<String, dynamic> profileData = {};

  @override
  void initState() {
    super.initState();
    fetchPatientData();
    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  Future<Map<String, dynamic>?> fetchPatientData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("patientList")
          .doc(userId()) // Ensure userId() returns a valid user ID
          .get();

      if (doc.exists) {
        // Convert the document data to a Map<String, dynamic>
        profileData = doc.data() as Map<String, dynamic>;
        setState(() {

        });
        return profileData;
      } else {
        // Document does not exist
        print("No document found for the provided user ID.");
        return null;
      }
    } catch (e) {
      // Handle any errors that occur
      print("Error fetching data: $e");
      return null;
    }
  }

  String userId(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    String userId = "";
    if(_auth.currentUser != null)
      {
        userId = _auth.currentUser!.uid;
      }
    return userId;
  }

  void animator() {
    setState(() {
      animate = !animate;
      opacity = animate ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 20),
              height: size.height * 0.28,
              width: size.width,
              child: Stack(
                children: [
                  // Profile Information Section
                  AnimatedPositioned(
                    left: animate ? 20 : -100,
                    duration: const Duration(milliseconds: 400),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: opacity,
                      child: Container(
                        padding: const EdgeInsets.only(top: 80, left: 20),
                        height: size.height / 2.5,
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              profileData["fullName"] ?? "",
                              25,
                              Colors.black,
                              FontWeight.bold,
                              letterSpace: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Biography Section
                  AnimatedPositioned(
                    top: animate ? 120 : 220,
                    left: 20,
                    right: 20,
                    duration: const Duration(milliseconds: 400),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: opacity,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextWidget(
                          profileData["email"] ?? "" ,
                          15,
                          Colors.black.withOpacity(.5),
                          FontWeight.normal,
                          letterSpace: 0,
                        ),
                      ),
                    ),
                  ),

                  // Back Button
                  AnimatedPositioned(
                    top: animate ? 20 : 100,
                    left: 20,
                    duration: const Duration(milliseconds: 400),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: opacity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              animator();
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: Get.width * 0.75,),
                          InkWell(
                            onTap: () {
                              CustomWidgets.showConfirmDialogWithActions(
                                  context,
                                  "Are you sure",
                                  "Yes", "No", () {
                                    FirebaseAuth.instance.signOut().whenComplete(() {
                                      Get.to(SelectScreen());
                                    },);

                                  }, () {

                                  },);

                            },
                            child: const Icon(
                              Icons.logout,
                              color: Colors.redAccent,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            FutureBuilder(
              future: FirebaseFirestore.instance.collection("patientSurveyReport").doc(userId()).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("No data found"));
                } else {
                  final data = snapshot.data!;
                  final answers = data['answers'] as List<dynamic>;

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columnSpacing: 20.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300)
                          ),
                          columns: const [
                            DataColumn(label: Text('Report', style: TextStyle(fontWeight:  FontWeight.w500),)),
                            DataColumn(label: Text('')),
                          ],
                          rows: answers.map<DataRow>((answer) {
                            final question = answer['question'] as String;
                            final selectedOption = answer['selected_option'] as String;

                            return DataRow(
                              cells: [
                                DataCell(Text(question)),
                                DataCell(Text(selectedOption), placeholder: true),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
