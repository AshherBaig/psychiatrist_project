import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String chatId;
  final List<Map<String, dynamic>> participants;
  final String lastMessage;
  final Timestamp lastMessageTime;

  ChatRoom({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatRoom.fromDocument(DocumentSnapshot doc) {
    return ChatRoom(
      chatId: doc.id,
      participants: List<Map<String, dynamic>>.from(doc['participants']),
      lastMessage: doc['lastMessage'],
      lastMessageTime: doc['lastMessageTime'],
    );
  }
}
