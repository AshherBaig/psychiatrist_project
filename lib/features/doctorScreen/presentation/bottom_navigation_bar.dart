import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/chat/screens/ChatRoomScreen.dart';
import 'package:psychiatrist_project/community_chat/ComChatScreen.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/features/doctorScreen/screens/Profile.dart';
import 'dart:math' as math;

import 'package:psychiatrist_project/size_confige.dart';

class DoctorBottomNavigation extends StatelessWidget {
  final List<IconData> itemIcons;
  final IconData centerIcon;
  final int selectedIndex;
  final Function(int) onItemPressed;
 // Assuming you pass the doctor's ID to this widget

  DoctorBottomNavigation({
    required this.itemIcons,
    required this.centerIcon,
    required this.selectedIndex,
    required this.onItemPressed, // Receive doctor ID here
  }) : assert(itemIcons.length != 3, "Item must equal 4");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String userId = user!.uid;
    return Container(
      height: getRelativeHeight(0.1),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: getRelativeHeight(0.07),
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: getRelativeWidth(0.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    //Home
                    GestureDetector(
                      onTap: () {
                        onItemPressed(0);
                      },
                      child: Icon(
                        itemIcons[0],
                        color: selectedIndex == 0
                            ? kPrimaryDarkColor
                            : kLightTextColor,
                        size: getRelativeWidth(0.09),
                      ),
                    ),


                    //Notifications
                    GestureDetector(
                      onTap: () {

                        Get.to(ComChatScreen());
                      },
                      child: Icon(
                        itemIcons[1],
                        color: selectedIndex == 1
                            ? kPrimaryDarkColor
                            : kLightTextColor,
                        size: getRelativeWidth(0.09),
                      ),
                    ),


                    // Spacer(flex: 3)

                    // Chat
                    GestureDetector(
                      onTap: () {
                       // Get.to(ComChatScreen());
                       Get.to(ChatRoomListScreen(
                          userId: userId,
                        ));
                      },
                      child: Icon(
                        itemIcons[2],
                        color: selectedIndex == 2
                            ? kPrimaryDarkColor
                            : kLightTextColor,
                        size: getRelativeWidth(0.09),
                      ),
                    ),


                    // Profile
                    GestureDetector(
                      onTap: () {
                        Get.to(Profile());
                      },
                      child: Icon(
                        itemIcons[3],
                        color: selectedIndex == 3
                            ? kPrimaryDarkColor
                            : kLightTextColor,
                        size: getRelativeWidth(0.09),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // // Map
          // Positioned.fill(
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Transform.rotate(
          //       angle: -math.pi / 4,
          //       child: Container(
          //         decoration: BoxDecoration(
          //           boxShadow: [
          //             BoxShadow(
          //               blurRadius: 25,
          //               offset: Offset(0, 5),
          //               color: kPrimaryDarkColor.withOpacity(0.75),
          //             )
          //           ],
          //           borderRadius: BorderRadius.all(Radius.circular(18)),
          //           gradient: LinearGradient(
          //             begin: Alignment.topCenter,
          //             end: Alignment.bottomCenter,
          //             colors: [
          //               kPrimarylightColor,
          //               kPrimaryDarkColor,
          //             ],
          //           ),
          //         ),
          //         height: getRelativeWidth(0.135),
          //         width: getRelativeWidth(0.135),
          //         child: Center(
          //             child: Transform.rotate(
          //               angle: math.pi / 4,
          //               child: Icon(
          //                 centerIcon,
          //                 color: Colors.white,
          //                 size: getRelativeWidth(0.07),
          //               ),
          //             )),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
