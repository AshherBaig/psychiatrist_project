import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/features/controllers/doctor_profile_controller.dart';
import 'package:psychiatrist_project/features/doctorScreen/screens/selectScreen.dart';
import 'package:psychiatrist_project/res/lists.dart';
import 'package:psychiatrist_project/widgets/custom_widgets.dart';
import 'package:psychiatrist_project/widgets/text_widget.dart';
import 'Oppointment.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DocProfileController _docProfileController = Get.find<DocProfileController>();
  AuthController _authController = Get.find<AuthController>();
  var animate = false;
  var opacity = 0.0;
  late Size size;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  void animator() {
    setState(() {
      animate = !animate;
      opacity = animate ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    log(_docProfileController.isMon.value.toString());
    log(_docProfileController.isTues.value.toString());
    log(_docProfileController.isWed.value.toString());
    log(_docProfileController.isThurs.value.toString());
    log(_docProfileController.isFri.value.toString());
    log(_docProfileController.isSat.value.toString());
    log(_docProfileController.isSun.value.toString());
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 20),
          width: size.width,
          child: Stack(
            children: [
              // Profile Information Section
              AnimatedPositioned(
                left: animate ? 20 : -100,
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: opacity,
                  child: Container(
                    padding: const EdgeInsets.only(top: 80, left: 20),
                    // height: size.height / 2.5,
                    width: size.width -  40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          _authController.nameAsADoctor.value,
                          25,
                          Colors.black,
                          FontWeight.bold,
                          letterSpace: 0,
                        ),
                        const SizedBox(height: 5),
                        TextWidget(
                          spacilality[0],
                          15,
                          Colors.black.withOpacity(.6),
                          FontWeight.bold,
                          letterSpace: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        
              // Biography Section
              AnimatedPositioned(
                top: animate ? 190 : 220,
                left: 20,
                right: 20,
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: opacity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       TextWidget("Biography", 25, Colors.black, FontWeight.bold),
                        const SizedBox(height: 20),
                        TextWidget(
                          "Famous doctor, hygienist, folklore researcher and sanitary mentor, Charles Laugier, whose contribution to the development",
                          15,
                          Colors.black.withOpacity(.5),
                          FontWeight.normal,
                          letterSpace: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        
              // Schedule Section
              AnimatedPositioned(
                left: 20,
                right: 20,
                bottom: animate ? -20 : -20,
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: opacity,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    height: 300,
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: TextWidget("Schedule", 25, Colors.black, FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return dayCard("Mon", () {
                                _docProfileController.isMon.value = !_docProfileController.isMon.value;
                                if(_docProfileController.isMon.value == false)
                                {
                                  _docProfileController.mon.value = 1;
                                }
                                else{
                                  _docProfileController.mon.value = 0;
                                }
                                _docProfileController.updateDay(docId: _authController.currentUserId, day: "mon", value: _docProfileController.mon.value);
                              }, _docProfileController.isMon.value);
                            },),

                            Obx(() {
                              return dayCard("Ture", () {
                                _docProfileController.isTues.value = !_docProfileController.isTues.value;
                                if(_docProfileController.isTues.value == false)
                                {
                                  _docProfileController.tue.value = 2;
                                }
                                else{
                                  _docProfileController.tue.value = 0;
                                }
                                _docProfileController.updateDay(docId: _authController.currentUserId, day: "tue", value: _docProfileController.tue.value);
                              },_docProfileController.isTues.value);
                            },),

                            Obx(() {
                              return dayCard("Wed", () {
                                _docProfileController.isWed.value = !_docProfileController.isWed.value;
                                if(_docProfileController.isWed.value == false)
                                {
                                  _docProfileController.wed.value = 3;
                                }
                                else{
                                  _docProfileController.wed.value = 0;
                                }
                                _docProfileController.updateDay(docId: _authController.currentUserId, day: "wed", value: _docProfileController.wed.value);
                              }, _docProfileController.isWed.value);
                            },),

                            Obx(() {
                              return dayCard("Thurs", () {
                                _docProfileController.isThurs.value = !_docProfileController.isThurs.value;
                                if(_docProfileController.isThurs.value == false)
                                {
                                  _docProfileController.thu.value = 4;
                                }
                                else{
                                  _docProfileController.thu.value = 0;
                                }
                                _docProfileController.updateDay(docId: _authController.currentUserId, day: "thurs", value: _docProfileController.thu.value);
                              },_docProfileController.isThurs.value);
                            },),

                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() {
                                return dayCard("Fri", () {
                                  _docProfileController.isFri.value = !_docProfileController.isFri.value;
                                  if(_docProfileController.isFri.value == false)
                                  {
                                    _docProfileController.fri.value = 5;
                                  }
                                  else{
                                    _docProfileController.fri.value = 0;
                                  }
                                  _docProfileController.updateDay(docId: _authController.currentUserId, day: "fri", value: _docProfileController.fri.value);
                                }, _docProfileController.isFri.value);
                              },),

                              Obx(() {
                                return dayCard("Sat", () {
                                  _docProfileController.isSat.value = !_docProfileController.isSat.value;
                                  if(_docProfileController.isSat.value == false)
                                  {
                                    _docProfileController.sat.value = 6;
                                  }
                                  else{
                                    _docProfileController.sat.value = 0;
                                  }
                                  _docProfileController.updateDay(docId: _authController.currentUserId, day: "sat", value: _docProfileController.sat.value);
                                }, _docProfileController.isSat.value);
                              },),

                              Obx(() {
                                return dayCard("Sun", () {
                                  _docProfileController.isSun.value = !_docProfileController.isSun.value;
                                  if(_docProfileController.isSun.value == false)
                                  {
                                    _docProfileController.sun.value = 7;
                                  }
                                  else{
                                    _docProfileController.sun.value = 0;
                                  }
                                  _docProfileController.updateDay(docId: _authController.currentUserId, day: "sun", value: _docProfileController.sun.value);
                                }, _docProfileController.isSun.value);
                              },),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
        
              // Back Button
              AnimatedPositioned(
                top: animate ? 20 : 100,
                left: 20,
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: opacity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          animator();
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: Get.width * 0.75,),
                      InkWell(
                        onTap: () {
                          CustomWidgets.showConfirmDialogWithActions(
                            context,
                            "Are you sure",
                            "Yes", "No", () {
                            FirebaseAuth.instance.signOut().whenComplete(() {
                              Get.to(SelectScreen());
                            },);

                          }, () {

                          },);

                        },
                        child: const Icon(
                          Icons.logout,
                          color: Colors.redAccent,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dayCard(String day, VoidCallback onTap, bool isChange){
    return InkWell(
      onTap: onTap,
      child: Card(
        color: isChange ? Colors.lightBlue : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.black54.withOpacity(0.1))
        ),
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: TextWidget(
              day,
              15,
              isChange ? Colors.white : Colors.black,
              FontWeight.bold,
              letterSpace: 0,
            ),
          ),
        ),
      ),
    );
  }
}
