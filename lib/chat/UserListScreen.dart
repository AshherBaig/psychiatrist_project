// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:psychiatrist_project/chat/ChatController.dart';
// import 'package:psychiatrist_project/chat/ChatScreen.dart';
//  // Make sure to import your ChatScreen file

// class UserListScreen extends StatelessWidget {
//   final ChatController chatController = Get.put(ChatController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('Doctor Name'), // Replace with the actual doctor's name
//             subtitle: Text('Tap to chat with Doctor'),
//             trailing: ElevatedButton(
//               onPressed: () async {
//                 // Assume current user is a patient and selected doctor ID
//                 String currentUserId = 'patientUserId'; // Replace with actual patient user ID
//                 String selectedDoctorId = 'doctorUserId'; // Replace with actual doctor user ID

//                 // Check if a chat already exists or create a new one
//                 String chatId = await chatController.createChatRoom(
//                   selectedDoctorId, // Doctor's user ID
//                   currentUserId, // Patient's user ID
//                 );

//                 // Navigate to the chat screen with the obtained chat ID
//                 Get.to(() => ChatScreen(chatId: chatId));
//               },
//               child: Text('Chat'),
//             ),
//           ),
//           // Add more list tiles for different doctors or patients
//         ],
//       ),
//     );
//   }
// }
