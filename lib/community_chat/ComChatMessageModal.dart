import 'package:cloud_firestore/cloud_firestore.dart';

class ComChatMessage {
  String senderId;
  String senderName;
  String message;
  Timestamp timestamp;

  ComChatMessage({
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory ComChatMessage.fromMap(Map<String, dynamic> map) {
    return ComChatMessage(
      senderId: map['senderId'],
      senderName: map['senderName'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
