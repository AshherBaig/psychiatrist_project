import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/widgets/text_widget.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'Profile.dart';

class Oppointment extends StatefulWidget {
  int index=0;
  String doctorId;
  String doctorName;
  String doctorSpec;
  Oppointment(this.index, this.doctorId, this.doctorName, this.doctorSpec);
  @override
  State<Oppointment> createState() => _OppointmentState();
}

class _OppointmentState extends State<Oppointment> {

  AuthController _authController = Get.find<AuthController>();
  var images=[

    const AssetImage('assets/images/doctor2.png'),
    const AssetImage('assets/images/doctor3.png'),
    const AssetImage('assets/images/doctor4.png'),
    const AssetImage('assets/images/doctor5.png'),
    const AssetImage('assets/images/doctor6.png'),
    const AssetImage('assets/images/doctor7.png'),
    const AssetImage('assets/images/doctor5.png'),
  ];
  late Size size;
  var animate = false;
  var opacity = 0.0;
  bool isLoading = false;

  var time = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDays();
    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  animator() {
    if (opacity == 0.0) {
      opacity = 1.0;
      animate = true;
    } else {
      opacity = 0.0;
      animate = false;
    }
    setState(() {});
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    log(args.value.toString());
    setState(() {
      selectedDate = formatToReadableDate(args.value);
    });
  }
  String formatToReadableDate(DateTime parsedDate) {
    log(DateFormat('d MMM yyyy').format(parsedDate));
    // Format the DateTime object to '13 Sept 2024'
    return DateFormat('d MMM yyyy').format(parsedDate);
  }

  String selectedDate = "";
  String selectedTime = "";

  fetchDays() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("doctorList").doc(widget.doctorId).get();
    int mon = doc["mon"];
    int tue = doc["tue"];
    int wed = doc["wed"];
    int thurs = doc["thurs"];
    int fri = doc["fri"];
    int sat = doc["sat"];
    int sun = doc["sun"];
    // Create a List<int> from the variables
    List<int> days = [mon, tue, wed, thurs, fri, sat, sun];

    // Remove 0 values from the list
    days.removeWhere((value) => value == 0);
    log(days.toString());
    _authController.blackoutDates.value = _generateBlackoutDates(days);
    setState(() {

    });
  }



  List<DateTime> _generateBlackoutDates(List<int> selectedDays) {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(Duration(days: 90));
    List<DateTime> blackoutDates = [];

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      if (selectedDays.contains(currentDate.weekday)) {
        blackoutDates.add(currentDate);
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    return blackoutDates;
  }


  @override
  Widget build(BuildContext context) {
    // fetchDays();
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Stack(
          children: [
            AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                top: animate ? 25 : 80,
                left: 1,
                bottom: 1,
                right: 1,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: opacity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  animator();
                                  Timer(const Duration(milliseconds: 500), () {
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Colors.black,
                                )),
                            TextWidget(
                              "Appointment",
                              25,
                              Colors.black,
                              FontWeight.bold,
                              letterSpace: 0,
                            ),
                            Container(
                              height: 10,
                            ),
                          ],
                        ),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Obx(() {
                            return SfDateRangePicker(
                              enablePastDates: false,
                              selectionMode: DateRangePickerSelectionMode.single,
                              initialSelectedDate: DateTime.now(),
                              maxDate: DateTime.now().add(Duration(days: 90)), // Restrict to one month ahead
                              backgroundColor: Colors.white,
                              selectionColor: Colors.blue, // Customize the selection color
                              toggleDaySelection: true,
                              selectionShape: DateRangePickerSelectionShape.circle,
                              selectionTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              headerStyle: const DateRangePickerHeaderStyle(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                todayTextStyle: TextStyle(
                                  color: Colors.red, // Highlight today's date differently
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              monthViewSettings: DateRangePickerMonthViewSettings(
                                blackoutDates: _authController.blackoutDates.value,
                                showTrailingAndLeadingDates: false, // Optionally hide dates from the previous/next month
                              ),
                              onSelectionChanged: _onSelectionChanged,
                              showNavigationArrow: true,
                            );
                          },),
                        ),



                        TextWidget(
                          "Time",
                          25,
                          Colors.black,
                          FontWeight.bold,
                          letterSpace: 0,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                changer(0);
                                selectedTime = "9: 00 Am";
                                setState(() {

                                });
                              },
                              child: _timeCard("09:00 Am", time[0]),
                            ),
                            InkWell(
                              onTap: () {
                                changer(1);
                                selectedTime = "9: 30 Am";
                                setState(() {

                                });
                              },
                              child: _timeCard("09:30 Am", time[1]),
                            ),
                            InkWell(
                              onTap: () {
                                changer(2);
                                selectedTime = "10: 00 Am";
                                setState(() {

                                });
                              },
                              child: _timeCard("10:00 Am", time[2]),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                changer(3);
                                selectedTime = "10: 30 Am";
                                setState(() {

                                });
                              },
                              child: _timeCard("10:30 Am", time[3]),
                            ),
                            InkWell(
                              onTap: () {
                                selectedTime = "11: 00 Am";
                                setState(() {

                                });
                                changer(4);
                              },
                              child: _timeCard("11:00 Am", time[4]),
                            ),
                            InkWell(
                              onTap: () {
                                selectedTime = "12: 00 Pm";
                                setState(() {

                                });
                                changer(5);
                              },
                              child: _timeCard("12:00 Pm", time[5]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),

            Positioned(
              bottom: 10,
              left: 30,
              right: 30,
              child: InkWell(
                onTap: () async {
                  if(selectedTime == "" || selectedDate == "")
                    {
                      Get.snackbar("Alert", "Select Date and Time");
                    }
                  else{
                    try{
                      FirebaseFirestore db = FirebaseFirestore.instance;
                      await db.collection("appointments").add({
                        "patientName": _authController.nameAsAPatient.value,
                        "patientId": _authController.currentUserId,
                        "doctorId": widget.doctorId,
                        "doctorName": widget.doctorName,
                        "doctorSpec": widget.doctorSpec,
                        "date": selectedDate,
                        "time": selectedTime,
                        "accept": false,
                        "cancel": false,
                        "timeStamp": Timestamp.now()
                      }).then((value) {
                        isLoading = true;
                        setState(() {

                        });

                      },).whenComplete(() {
                        log("Appointment Booked");
                        isLoading = false;
                        selectedTime = "";
                        selectedDate = "";
                        time = [
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                        ];
                        setState(() {

                        });
                        showModalBottomSheet(
                          barrierColor: Colors.black.withOpacity(.8),
                          backgroundColor: Colors.transparent,
                          isDismissible: true,
                          context: context,
                          builder: (context) {
                            return SizedBox(
                                height:
                                MediaQuery.of(context).size.height /
                                    1.7,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: MediaQuery.of(context)
                                            .size
                                            .height /
                                            1.9,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.white,
                                                  blurRadius: 40),
                                            ],
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.topRight,
                                                colors: [
                                                  Colors.blue,
                                                  Colors.green,
                                                  Colors.red,
                                                  Colors.white,
                                                  Colors.yellow,
                                                  Colors.blue,
                                                  Colors.green,
                                                  Colors.red,
                                                  Colors.white,
                                                  Colors.yellow,
                                                  Colors.blue,
                                                  Colors.green,
                                                  Colors.red,
                                                  Colors.white,
                                                  Colors.yellow,
                                                  Colors.blue,
                                                  Colors.green,
                                                  Colors.red,
                                                  Colors.white,
                                                  Colors.yellow,
                                                ]),
                                            borderRadius:
                                            BorderRadius.only(
                                                topLeft:
                                                Radius.circular(
                                                  40,
                                                ),
                                                topRight:
                                                Radius.circular(
                                                    40))),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 100,
                                              left: 20,
                                              right: 20),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height /
                                              1.93,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(
                                                    40,
                                                  ),
                                                  topRight:
                                                  Radius.circular(
                                                      40))),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors
                                                      .black
                                                      .withOpacity(.1),
                                                  radius: 60,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color:
                                                      Colors.orange,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text(
                                                  "Successed",
                                                  style: TextStyle(
                                                      color:
                                                      Colors.orange,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.white,
                                                    blurRadius: 10,
                                                    offset:
                                                    Offset(0, 10)),
                                                BoxShadow(
                                                    color: Colors
                                                        .transparent,
                                                    offset:
                                                    Offset(10, 0)),
                                                BoxShadow(
                                                    color: Colors
                                                        .transparent,
                                                    offset:
                                                    Offset(-10, 0))
                                              ],
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: images[widget.index])),
                                        )),
                                  ],
                                ));
                          },
                        );
                      },).onError((error, stackTrace) {
                        isLoading = false;
                        selectedTime = "";
                        selectedDate = "";
                        time = [
                          false,
                          false,
                          false,
                          false,
                          false,
                          false,
                        ];
                        setState(() {

                        });
                      },);
                    }
                    catch(e){
                      log(e.toString());
                    }

                  }
                },
                child: Container(
                  height: 65,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue.shade900,
                  ),
                  child: !isLoading ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        "Book an appointment",
                        18,
                        Colors.white,
                        FontWeight.w500,
                        letterSpace: 1,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
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
                  ) : Center(child: CircularProgressIndicator(color: Colors.white,),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _timeCard(String oppointmentTime, bool isSelected){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      color: isSelected ? Colors.blue : Colors.white,
      child: Center(
        child: SizedBox(
            height: 60,
            width: 100,
            child: Center(
                child: TextWidget(
                  oppointmentTime,
                  17,
                  Colors.black,
                  FontWeight.bold,
                  letterSpace: 1,
                ))),
      ),
    );
  }

  void changer(int ind) {
    for (int i = 0; i < 6; i++) {
      if (i == ind) {
        time[i] = true;
      } else {
        time[i] = false;
      }
    }
    setState(() {});
  }
}
