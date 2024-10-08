import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:psychiatrist_project/model.dart/category.dart';
import 'package:psychiatrist_project/model.dart/doctor.dart';

class Data {
  static final categoriesList = [
    Category(
      title: "VR Therapy",
      doctorsNumber: 3,
      icon: Icons.favorite,
    ),
    Category(
      title: "Quran Therapy",
      doctorsNumber: 2,
      icon: LineIcons.bookReader,
    ),
    Category(
      title: "Physical Exercise Video",
      doctorsNumber: 1,
      icon: Icons.line_style,
    ),
    Category(
      title: "Optic",
      doctorsNumber: 10,
      icon: LineIcons.eye,
    ),
  ];

  static final doctorsList = [
    Doctor(
        name: "Dr.Hegazy Ali",
        speciality: "Cardiology",
        image: "assets/images/doctor_1.png",
        reviews: 80,
        reviewScore: 4),
    Doctor(
        name: "Dr.Dani",
        speciality: "Dermatology",
        image: "assets/images/doctor_2.png",
        reviews: 67,
        reviewScore: 5),
    Doctor(
        name: "Dr George",
        speciality: "Ophthalmology",
        image: "assets/images/doctor_3.png",
        reviews: 19,
        reviewScore: 3),
   
  ];
}
