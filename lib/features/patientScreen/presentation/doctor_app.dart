import 'package:flutter/material.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/appbar.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/banner.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/bottom_navigation_bar.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/doctors_list.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getRelativeHeight(0.025)),
              DoctorAppBar(),
              SizedBox(height: getRelativeHeight(0.015)),
              DoctorBanner(),
              SizedBox(height: getRelativeHeight(0.005)),
              SearchField(),
              SizedBox(height: getRelativeHeight(0.025)),
              CategoriesList(),
              SizedBox(height: getRelativeHeight(0.01)),
              DoctorsList()
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
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
