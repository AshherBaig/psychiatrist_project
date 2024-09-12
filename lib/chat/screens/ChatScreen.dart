import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:psychiatrist_project/chat/model/ChatMessage.dart';
import 'package:psychiatrist_project/chat/model/ChatRoomModel.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/features/doctorScreen/presentation/patientReportScreen.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  final String recieverName;
  final String recieverId;
  bool isDoctor;

  ChatScreen({required this.chatRoom, required this.recieverName, required this.recieverId, required this.isDoctor});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('personalChats').doc(widget.chatRoom.chatId).collection("message").add({
        'chatId': widget.chatRoom.chatId,
        'senderId': authController.currentUserId,
        'senderName': (authController.isDoctor.value) ? authController.nameAsADoctor.value : authController.nameAsADoctor.value,
        'message': _messageController.text,
        'timestamp': Timestamp.now(),
      });

      FirebaseFirestore.instance.collection('personalChats').doc(widget.chatRoom.chatId).update({
        'lastMessage': _messageController.text,
        'lastMessageTime': Timestamp.now(),
      });

      _messageController.clear();
    }
  }

  String formatTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recieverName,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
        actions: (widget.isDoctor) ? [
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () {
              Get.to(Patientreportscreen(patientId: widget.recieverId, patientName: widget.recieverName));
            },
          ),
        ] : [],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('personalChats').doc(widget.chatRoom.chatId)
                  .collection('message')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Say Hi", style: TextStyle(color: Colors.grey, fontSize: 16)));
                } else {
                  return ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var message = ChatMessage.fromDocument(snapshot.data!.docs[index]);
                      bool isCurrentUser = message.senderId == authController.currentUserId;

                      return Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.teal : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: isCurrentUser ? Radius.circular(12) : Radius.circular(0),
                              bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: isCurrentUser ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatTime(message.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isCurrentUser ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}