import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/data/data.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/IslamicTherapy.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/VRTherapy.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/physical_excersic_video.dart';
import 'package:psychiatrist_project/size_confige.dart';

class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: getRelativeHeight(0.085),
        child: ListView.builder(
          itemCount: Data.categoriesList.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.035)),
          itemBuilder: (context, index) {
            final category = Data.categoriesList[index];
            return InkWell(
              onTap: () {
                // Navigate to different screens based on the selected category
                switch (category.title) {
                  case "VR Therapy":
                    Get.to(() => VRTherapy());
                    break;
                  case "Quran Therapy":
                    Get.to(() => IslamicVRTherapy());
                    break;
                  case "Physical Exercise Video":
                    Get.to(() => PhysicalExcersicVideo());
                    break;
                  case "Optic":
                    Get.to(() => VRTherapy());
                    break;
                  default:
                    // Default action if no case matches
                    print("No screen available for this category");
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: getRelativeHeight(0.1),
                    constraints:
                        BoxConstraints(minWidth: getRelativeWidth(0.41)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getRelativeWidth(0.03)),
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.all(getRelativeWidth(0.025)),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      kCategoriesPrimaryColor[index],
                                      kCategoriesSecondryColor[index],
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(
                                category.icon,
                                color: Colors.white,
                                size: getRelativeWidth(0.075),
                              )),
                          SizedBox(width: getRelativeWidth(0.02)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.title,
                                style: TextStyle(
                                    fontSize: getRelativeWidth(0.038),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: getRelativeHeight(0.005)),
                              Text(
                                category.doctorsNumber.toString() + " doctors",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.48),
                                    fontSize: getRelativeWidth(0.03)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: getRelativeWidth(0.04))
                ],
              ),
            );
          },
        ));
  }
}
