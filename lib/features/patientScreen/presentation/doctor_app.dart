import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/appbar.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/banner.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/bottom_navigation_bar.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/doctors_list.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/banner.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/bottom_navigation_bar.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/search_field.dart';
import 'package:psychiatrist_project/size_confige.dart';
import 'appbar.dart';
import 'categories_list.dart';

class PatientScreen extends StatefulWidget {
  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  int _selectedIndex = 0;
  AuthController _authController = Get.find<AuthController>();
  String convertTimestampToReadableTime(Timestamp timestamp) {
    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to a readable string with AM/PM
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getRelativeHeight(0.025)),
              PatientAppBar(),
              SizedBox(height: getRelativeHeight(0.015)),
              PatientBanner(),
              SizedBox(height: getRelativeHeight(0.035)),
              CategoriesList(),
              SizedBox(height: getRelativeHeight(0.01)),
              DoctorsList(),
              SizedBox(height: getRelativeHeight(0.01)),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Your Doctor Appointments", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),)),
              ),
              Card(
                elevation: 3,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('appointments')
                      .where('patientId', isEqualTo: _authController.currentUserId)
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
                          SizedBox(height: Get.height * 0.1,),
                          Center(child: Text('No Appointments Available.')),
                          SizedBox(height: Get.height * 0.1,),
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
                              trailing: accept ? Text("Approved") : cancel ? Text("Cancelled") : Text("Pending"),
                              title: Text("${snapshot.data!.docs[index]['doctorName']} (${snapshot.data!.docs[index]['doctorSpec']})" ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data!.docs[index]['date']),
                                  Text(snapshot.data!.docs[index]['time']),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: PatientBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemPressed: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        centerIcon: Icons.place,
        itemIcons: [
          Icons.home,
          Icons.notifications,
          Icons.message,
          Icons.account_box,
        ],
      ),
    );
  }
}
