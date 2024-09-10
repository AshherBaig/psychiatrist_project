import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/appbar.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/banner.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/bottom_navigation_bar.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/categories_list.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/doctors_list.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/appbar.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/banner.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/bottom_navigation_bar.dart';
import 'package:psychiatrist_project/size_confige.dart';

class PatientScreen extends StatefulWidget {
  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  int _selectedIndex = 0;
  AuthController _authController = Get.find<AuthController>();

  String convertTimestampToReadableTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
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
                SizedBox(height: getRelativeHeight(0.02)),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your Doctor Appointments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getRelativeHeight(0.02)),
                Appointments(),
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
      ),
    );
  }

  Widget Appointments() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('patientId', isEqualTo: _authController.currentUserId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.1),
                  Center(
                    child: Icon(Icons.calendar_today, size: 80, color: Colors.grey[400]),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'No Appointments Available',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.1),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              bool accept = doc['accept'];
              bool cancel = doc['cancel'];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      "${doc['doctorName']} (${doc['doctorSpec']})",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          "Date: ${doc['date']}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          "Time: ${doc['time']}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: _getStatusLabel(accept, cancel),
                    isThreeLine: true,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getStatusLabel(bool accept, bool cancel) {
    if (accept) {
      return Chip(
        label: Text(
          "Approved",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      );
    } else if (cancel) {
      return Chip(
        label: Text(
          "Cancelled",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      );
    } else {
      return Chip(
        label: Text(
          "Pending",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orangeAccent,
      );
    }
  }
}
