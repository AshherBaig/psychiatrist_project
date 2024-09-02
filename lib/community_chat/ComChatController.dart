import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:psychiatrist_project/community_chat/ComChatMessageModal.dart';

class Comchatcontroller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<ComChatMessage> messages = <ComChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchMessages();
  }

  void _fetchMessages() {
    _firestore.collection('chats').orderBy('timestamp', descending: true).snapshots().listen((snapshot) {
      messages.value = snapshot.docs.map((doc) => ComChatMessage.fromMap(doc.data())).toList();
    });
  }
  Future<void> sendMessage(String message, String senderId, String senderName) async {
    final newMessage = ComChatMessage(
      senderId: senderId,
      senderName: senderName,
      message: message,
      timestamp: Timestamp.now(),
    );

    await _firestore.collection('chats').add(newMessage.toMap());
  }
}
