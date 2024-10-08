import 'package:flutter/material.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/size_confige.dart';



class PatientBanner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: getRelativeWidth(0.94),
          height: getRelativeHeight(0.22),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: getRelativeWidth(0.88),
                height: getRelativeHeight(0.17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 40,
                      offset: Offset(0, 15),
                      color: kPrimaryDarkColor,
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff77E2FE),
                      Color(0xff46BDFA),
                    ],
                  ),
                ),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: getRelativeWidth(0.03)),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: 1.0,
                              top: 2.0,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.black54,
                                size: getRelativeHeight(0.1),
                              ),
                            ),
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: getRelativeHeight(0.1),
                            ),
                            Icon(
                              Icons.healing,
                              color: Colors.white,
                              size: getRelativeHeight(0.05),
                            ),
                          ],
                        ),
                        // SizedBox(width: getRelativeWidth(0.012)),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome to E Psychiatrist",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: getRelativeWidth(0.055),
                                ),
                              ),
                              SizedBox(height: getRelativeHeight(0.02)),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Contains several list of questions to check your Mental health condition.",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.85),
                                          fontSize: getRelativeWidth(0.033)),
                                    ),
                                  ),
                                  SizedBox(width: getRelativeWidth(0.03)),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    padding:
                                    EdgeInsets.all(getRelativeWidth(0.012)),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: getRelativeWidth(0.038),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}