import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/size_confige.dart';
  

class DoctorAppBar extends StatelessWidget {
final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.04)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${authController.nameAsADoctor.value}!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: getRelativeWidth(0.09)),
              ),
              SizedBox(height: getRelativeHeight(0.003)),
              Text(
                "Find A Doctor & Specialist easily",
                style: TextStyle(
                    color: Colors.blueGrey[400],
                    fontSize: getRelativeWidth(0.036)),
              ),
            ],
          ),
          Container(
            height: getRelativeHeight(0.06),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset(0, 4),
                    color: Colors.black54,
                  )
                ],
                color: Color(0xffA295FD),
                borderRadius: BorderRadius.circular(5)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset("assets/images/person.png")),
          )
        ],
      ),
    );
  }
}
