import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/chat/ChatMessage.dart';


class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<ChatMessage> messages = RxList<ChatMessage>();
  RxList<Map<String, dynamic>> doctors = RxList<Map<String, dynamic>>(); // List of doctors fetched from Firestore
  String currentUserId = 'patientUserId'; // Replace with actual patient user ID
  String currentUserName = 'Patient Name'; // Replace with actual patient user name

  @override
  void onInit() {
    super.onInit();
    fetchDoctors(); // Fetch doctors when controller is initialized
  }

  void fetchDoctors() async {
    // Fetch list of doctors from Firestore
    QuerySnapshot querySnapshot = await _firestore.collection('doctorList').get();
    doctors.value = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Fetch messages for a specific chat room
  void fetchMessages(String chatId) {
    _firestore
        .collection('personalChats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) => ChatMessage.fromDocument(doc)).toList();
    });
  }

  // Send a new message
  void sendMessage(String chatId, String message, String senderId, String senderName) {
    _firestore.collection('personalChats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': Timestamp.now(),
    });

    _firestore.collection('personalChats').doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': Timestamp.now(),
    });
  }


// Create or fetch a chat room between two users
  Future<String> createChatRoom(String userId1, String userId2) async {
    bool chatRoomExist = false;
    String chatRoomId = "";
    // Fetch chat rooms where the current user is a participant
    QuerySnapshot querySnapshot = await _firestore.collection('personalChats')
        .where('participantIds', arrayContains: userId1)
        .get();

    log(querySnapshot.docs.length.toString());
    // Check if the chat room already exists with the second user
    for (var doc in querySnapshot.docs) {
      List<dynamic> participants = doc['participantIds'];

      log("In Loop");
      // Check if the other user is also a participant
      if (participants.contains(userId2)) {
        log("if");
        chatRoomExist = true;
        chatRoomId = doc.id; // Chat room exists, return the chat room ID
        break; // Exit the loop once found
      }
    }

    if(!chatRoomExist)
      {
        log("Else");
        DocumentReference docRef = await _firestore.collection('personalChats').add({
          'participants': [
            {'userId': userId1, 'role': 'patient'},
            {'userId': userId2, 'role': 'doctor'}
          ],
          "participantIds": [userId1, userId2],  // This simplifies querying
          'lastMessage': '',
          'lastMessageTime': Timestamp.now(),
        });
        chatRoomId = docRef.id;
      }
    // If no chat room exists, create a new one


    return chatRoomId; // Return new chat room ID
  }



// Create or fetch a chat room between two users
//   Future<String> createChatRoom(String userId1, String userId2) async {
//     String chatRoomId = "";
//     try {
//       final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//       // Query chat rooms where either user is a participant
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('personalChats')
//           .where('participants', arrayContains: {'userId': userId1})
//           .get();
//
//       log("querySnapshot: ${querySnapshot.docs.length}");
//
//       // Check if a chat room exists with both users as participants
//       for (var doc in querySnapshot.docs) {
//         List<dynamic> participants = doc['participants'];
//         log("participants: $participants");
//         bool user1Exists = participants.any((p) => p['userId'] == userId1);
//         bool user2Exists = participants.any((p) => p['userId'] == userId2);
//
//         log("user1Exists: $user1Exists \n user2Exists: $user2Exists");
//
//         if (user1Exists && user2Exists) {
//           log("If____________");
//           // Chat room with both participants found, return its ID
//           print("Chat room exists. Returning existing chat room ID.");
//           chatRoomId = doc.id;
//         }
//         else{
//           log("Else____________");
//           // If no chat room exists with both users, create a new chat room
//           print("No existing chat room found. Creating a new chat room.");
//           DocumentReference docRef = await _firestore.collection('personalChats').add({
//             'participants': [
//               {'userId': userId1, 'role': 'patient'},
//               {'userId': userId2, 'role': 'doctor'},
//             ],
//             'lastMessage': '',
//             'lastMessageTime': Timestamp.now(),
//           });
//           chatRoomId = docRef.id;
//         }
//       }
//
//
//
//       // Return the ID of the newly created chat room
//       return chatRoomId;
//     } catch (e) {
//       print("Error creating chat room: $e");
//       return chatRoomId;
//     }
//   }



}
