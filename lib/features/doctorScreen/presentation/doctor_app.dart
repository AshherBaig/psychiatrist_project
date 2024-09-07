import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/banner.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/bottom_navigation_bar.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/doctors_list.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/search_field.dart';
import 'package:psychiatrist_project/size_confige.dart';
import 'appbar.dart';
import 'categories_list.dart';

class DoctorDashboardScreen extends StatefulWidget {
  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  AuthController _authController = Get.find<AuthController>();
  int _selectedIndex = 0;
  FirebaseFirestore db = FirebaseFirestore.instance;

  String convertTimestampToReadableTime(Timestamp timestamp) {
    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to a readable string with AM/PM
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }

  void approveAppointment(String id){
    FirebaseFirestore.instance
        .collection('appointments').doc(id).update({
      "accept": true
    }).whenComplete(() {
      Get.back();
      Get.snackbar("Success", "Appointment Accepted");
    },).onError((error, stackTrace) {
      Get.snackbar("Error", "$error");
    },);
  }
  void cancelAppointment(String id){
    FirebaseFirestore.instance
        .collection('appointments').doc(id).update({
      "cancel": true
    }).whenComplete(() {
      Get.back();
      Get.snackbar("Success", "Appointment Cancelled");
    },).onError((error, stackTrace) {
      Get.snackbar("Error", "$error");
    },);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Close the application
        SystemNavigator.pop();
        return false; // Prevent default back button behavior (do not navigate back)
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getRelativeHeight(0.025)),
                DoctorAppBar(),
                SizedBox(height: getRelativeHeight(0.015)),
                DoctorBanner(),
                SizedBox(height: getRelativeHeight(0.035)),
                Center(child: Text("Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),),
                SizedBox(height: getRelativeHeight(0.01)),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('appointments')
                      .where('doctorId', isEqualTo: _authController.currentUserId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator()); // Show a loading spinner
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}')); // Display any error
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: Get.height * 0.15,),
                          Center(child: Text('No Appointments Available.')),
                          SizedBox(height: Get.height * 0.5,),
                        ],
                      ); // Show message if no data
                    }

                    // Data is available
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        bool accept = snapshot.data!.docs[index]['accept'];
                        bool cancel = snapshot.data!.docs[index]['cancel'];
                        // Customize your UI for each document here
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Card(
                            elevation: 0.5,
                            child: ListTile(
                              trailing: accept ? Text("Approved") : cancel ? Text("Cancelled") : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: () {
                                    Get.defaultDialog(
                                      title: "Confirmation",
                                      middleText: "Are you sure you want to approve it?",
                                      textConfirm: "YES",
                                      textCancel: "NO",
                                      onConfirm: () {
                                        approveAppointment(snapshot.data!.docs[index].id);
                                      },
                                      onCancel: () {

                                      },
                                    );
                                  }, icon: Icon(Icons.check_circle, color: Colors.green,)),
                                  IconButton(onPressed: () {
                                    Get.defaultDialog(
                                      title: "Confirmation",
                                      middleText: "Are you sure you want to cancel it?",
                                      textConfirm: "YES",
                                      textCancel: "NO",
                                      onConfirm: () {

                                        cancelAppointment(snapshot.data!.docs[index].id);
                                      },
                                      onCancel: () {

                                      },
                                    );
                                  }, icon: Icon(Icons.cancel, color: Colors.red,)),
                                ],
                              ),
                              title: Text(snapshot.data!.docs[index]['patientName'] ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data!.docs[index]['date']),
                                  Text(snapshot.data!.docs[index]['time']),
                                  Text("Posted on ${convertTimestampToReadableTime(snapshot.data!.docs[index]['timeStamp'])}"),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )


                // Container(
                //   height: Get.height * 0.5,
                //   margin: EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey),
                //     borderRadius: BorderRadius.circular(10)
                //   ),
                //   child: Center(
                //     child: Text("No Appointments Yet",style: TextStyle(color: Colors.black87),),
                //   ),
                // )


                // CategoriesList(),
                // SizedBox(height: getRelativeHeight(0.01)),
                // DoctorsList()
              ],
            ),
          ),
        ),
        bottomNavigationBar: DoctorBottomNavigation(
          selectedIndex: _selectedIndex,
          onItemPressed: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          centerIcon: Icons.place,
          itemIcons: [
            Icons.home,
            Icons.groups,
            Icons.message,
            Icons.account_box,
          ],
        ),
      ),
    );
  }
}
