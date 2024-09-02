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
    QuerySnapshot querySnapshot = await _firestore.collection('personalChats')
        .where('participants', arrayContains: {'userId': userId1})
        .get();

    for (var doc in querySnapshot.docs) {
      List<dynamic> participants = doc['participants'];
      if (participants.any((p) => p['userId'] == userId2)) {
        return doc.id; // Chat room exists, return the chat ID
      }
    }

    DocumentReference docRef = await _firestore.collection('personalChats').add({
      'participants': [
        {'userId': userId1, 'role': 'patient'},
        {'userId': userId2, 'role': 'doctor'}
      ],
      'lastMessage': '',
      'lastMessageTime': Timestamp.now(),
    });

    return docRef.id; // Return new chat room ID
  }
}
