import 'package:flutter/material.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/model.dart/doctor_model.dart';
import 'package:psychiatrist_project/size_confige.dart';

class DoctorDetailPage extends StatelessWidget {
  final DoctorModel doctor;

  DoctorDetailPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(getRelativeWidth(0.05)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor.fullName,
              style: TextStyle(
                fontSize: getRelativeWidth(0.07),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getRelativeHeight(0.02)),
            Text(
              'Specialization: ${doctor.specialization}',
              style: TextStyle(fontSize: getRelativeWidth(0.05)),
            ),
            SizedBox(height: getRelativeHeight(0.01)),
            Text(
              'Address: ${doctor.address}',
              style: TextStyle(fontSize: getRelativeWidth(0.05)),
            ),
            SizedBox(height: getRelativeHeight(0.01)),
            Text(
              'University: ${doctor.uniName}',
              style: TextStyle(fontSize: getRelativeWidth(0.05)),
            ),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}
