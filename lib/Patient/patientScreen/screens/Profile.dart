import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/Patient/controllers/authController.dart';
import 'package:psychiatrist_project/res/lists.dart';
import 'package:psychiatrist_project/widgets/text_widget.dart';
import 'Oppointment.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20),
        height: size.height,
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
                  height: size.height / 2.5,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        names[0],
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
              top: animate ? 180 : 220,
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
              bottom: animate ? 80 : -20,
              duration: const Duration(milliseconds: 400),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacity,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget("Schedule", 25, Colors.black, FontWeight.bold),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    "${19 + index}",
                                    15,
                                    Colors.black,
                                    FontWeight.bold,
                                    letterSpace: 0,
                                  ),
                                  TextWidget(
                                    "Thu",
                                    15,
                                    Colors.black,
                                    FontWeight.bold,
                                    letterSpace: 0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Make an Appointment Button
            AnimatedPositioned(
              bottom: animate ? 20 : -80,
              left: 20,
              right: 20,
              duration: const Duration(milliseconds: 400),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacity,
                child: InkWell(
                  onTap: () async {
                    animator();
                    await Future.delayed(const Duration(milliseconds: 400));
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Oppointment(0)),
                    );
                    animator();
                  },
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue.shade900,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          "Make an appointment",
                          18,
                          Colors.white,
                          FontWeight.w500,
                          letterSpace: 1,
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white.withOpacity(.5),
                          size: 18,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white.withOpacity(.2),
                          size: 18,
                        ),
                      ],
                    ),
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
                child: InkWell(
                  onTap: () {
                    animator();
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
