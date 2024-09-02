import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/features/controllers/doctorListController.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/DoctorDetailPage.dart';
import 'package:psychiatrist_project/size_confige.dart';
 // Import the new detail page

class DoctorsList extends StatelessWidget {
  final DoctorController doctorController = Get.find<DoctorController>();

  @override
  Widget build(BuildContext context) {
    doctorController.fetchDoctorList();
    return Obx(() {
      if (doctorController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (doctorController.doctorList.isEmpty) {
        return Center(child: Text('No doctors found.'));
      }

      return Container(
        height: getRelativeHeight(0.35),
        child: ListView.builder(
          itemCount: doctorController.doctorList.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.035)),
          itemBuilder: (context, index) {
            final doctor = doctorController.doctorList[index];
            final color = kCategoriesSecondryColor[
                (kCategoriesSecondryColor.length - index - 1)];
            final circleColor = kCategoriesPrimaryColor[
                (kCategoriesPrimaryColor.length - index - 1)];
            final cardWidth = getRelativeWidth(0.48);

            return GestureDetector(
              onTap: () {
                Get.to(() => DoctorDetailPage(doctor: doctor));
              },
              child: Padding(
                padding: EdgeInsets.only(
                    right: getRelativeWidth(0.03)), // Add spacing between items
                child: Container(
                  width: cardWidth, // Set a finite width
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: getRelativeHeight(
                                0.19), // Set a finite height for image container
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                        ),
                                        color: color,
                                      ),
                                      height: getRelativeHeight(
                                          0.14), // Ensure height is finite
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              width: getRelativeHeight(0.13),
                                              height: getRelativeHeight(0.13),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 15,
                                                    color: circleColor
                                                        .withOpacity(0.6)),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              width: getRelativeHeight(0.11),
                                              height: getRelativeHeight(0.11),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 15,
                                                    color: circleColor
                                                        .withOpacity(0.25)),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              width: getRelativeHeight(0.11),
                                              height: getRelativeHeight(0.11),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 15,
                                                    color: circleColor
                                                        .withOpacity(0.17)),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: getRelativeHeight(0.12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: getRelativeHeight(0.01),
                                  horizontal: getRelativeWidth((0.05))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.fullName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kHardTextColor,
                                        fontSize: getRelativeWidth(0.051)),
                                  ),
                                  SizedBox(height: getRelativeHeight(0.005)),
                                  Text(
                                    doctor.specialization,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: getRelativeWidth(0.032)),
                                  ),
                                  SizedBox(height: getRelativeHeight(0.005)),
                                  Text(
                                    doctor.address,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: getRelativeWidth(0.032)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: getRelativeHeight(0.04))
                                .copyWith(left: cardWidth * 0.7),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                  color: Colors.black26,
                                )
                              ], color: Colors.white, shape: BoxShape.circle),
                              padding: EdgeInsets.all(getRelativeWidth(0.015)),
                              child: Icon(
                                FontAwesomeIcons.facebookMessenger,
                                color: color,
                                size: getRelativeWidth(0.055),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(top: getRelativeHeight(0.14))
                                      .copyWith(left: cardWidth * 0.7),
                              child: Text(
                                doctor.uniName,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: getRelativeWidth(0.032)),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
