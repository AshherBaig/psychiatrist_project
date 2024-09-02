import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/features/auth/signInScreen.dart';
import 'package:psychiatrist_project/widgets/text_widget.dart';
class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen>
    with SingleTickerProviderStateMixin {
  bool position = false;
  var opacity = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  animator() async {
    if (opacity == 0) {
      opacity = 1;
      position = true;
    } else {
      opacity = 0;
      position = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: position ? 60 : 150,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 80,
                        width: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      "I'm",
                      60,
                      Colors.black,
                      FontWeight.bold,
                      letterSpace: 4,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
                top: position ? 240 : 150,
                left: position ? 0 : 150,
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: opacity,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.amber,
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          onTap: (){
                           Get.to(SignInPage(), arguments: {'role': 'Doctor'});
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  TextWidget(
                                    "Doctor",
                                    30,
                                    Colors.white,
                                    FontWeight.bold,
                                    letterSpace: 4,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              Container(
                                height: 150,
                                width: 100,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/images/doc1.png'),
                                        fit: BoxFit.fill)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        color: const Color(0xFF00D0C3),
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          onTap: (){
                           Get.to(SignInPage(), arguments: {'role': 'Patient'});
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 150,
                                width: 130, 
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/patient.png'),
                                        fit: BoxFit.fill)),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Column(
                                children: [
                                  TextWidget(
                                    "Patient",
                                    30,
                                    Colors.white,
                                    FontWeight.bold,
                                    letterSpace: 4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
