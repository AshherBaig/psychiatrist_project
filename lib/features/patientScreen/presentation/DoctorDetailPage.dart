import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:psychiatrist_project/chat/controller/ChatController.dart';
import 'package:psychiatrist_project/chat/screens/ChatRoomScreen.dart';
import 'package:psychiatrist_project/chat/screens/ChatScreen.dart';
import 'package:psychiatrist_project/community_chat/ComChatScreen.dart';
import 'package:psychiatrist_project/constants.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/model.dart/doctor_model.dart';
import 'package:psychiatrist_project/size_confige.dart';
import 'package:psychiatrist_project/widgets/text_widget.dart';

class DoctorDetailPage extends StatefulWidget {
  final DoctorModel doctor;

  DoctorDetailPage({required this.doctor});

  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  var animate = false;
  var opacity = 0.0;
  final ChatController chatController = Get.put(ChatController());
final AuthController authController = Get.find<AuthController>();

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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getRelativeWidth(0.05)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedPositioned(
                left: animate ? 20 : -100,
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: opacity,
                  child: Container(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.fullName,
                          style: TextStyle(
                            fontSize: getRelativeWidth(0.07),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: getRelativeHeight(0.02)),
                        Text(
                          'Specialization: ${widget.doctor.specialization}',
                          style: TextStyle(fontSize: getRelativeWidth(0.05)),
                        ),
                        SizedBox(height: getRelativeHeight(0.01)),
                        Text(
                          'Address: ${widget.doctor.address}',
                          style: TextStyle(fontSize: getRelativeWidth(0.05)),
                        ),
                        SizedBox(height: getRelativeHeight(0.01)),
                        Text(
                          'University: ${widget.doctor.uniName}',
                          style: TextStyle(fontSize: getRelativeWidth(0.05)),
                        ),
                        SizedBox(height: getRelativeHeight(0.01)),
                        Text(
                          'Years of Experience: ${widget.doctor.yearsOfExperience}',
                          style: TextStyle(fontSize: getRelativeWidth(0.05)),
                        ),
                      
                        SizedBox(height: getRelativeHeight(0.02)),
                      ],
                    ),
                  ),
                ),
              ),
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
                        Text("Biography", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Text(
                          "Famous doctor, hygienist, folklore researcher and sanitary mentor, Charles Laugier, whose contribution to the development",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black.withOpacity(.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Schedule Section (if needed)
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
                        Text("Schedule", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
                                    Text(
                                      "${19 + index}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Thu",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                    String currentUserId = authController.currentUserId; // Patient's ID
                 

                  // // Fetch doctor's details using AuthController
                  // var doctorDetails = await authController.getUserById(selectedDoctorId);
                  // String recipientName = doctorDetails['fullName'];

                  // Create or get the chat room ID
                  // String chatId = await chatController.createChatRoom(currentUserId, "${widget.doctor.id}");

                  // Navigate to the Chat Screen with the obtained chat ID
                  Get.to(() => ChatRoomListScreen(userId: '${widget.doctor.id}'));
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
                          "Chat With Doc",
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

            ],
          ),
        ),
      ),
    );
  }
}
