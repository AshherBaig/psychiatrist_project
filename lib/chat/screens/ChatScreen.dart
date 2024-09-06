import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:psychiatrist_project/chat/model/ChatMessage.dart';
import 'package:psychiatrist_project/chat/model/ChatRoomModel.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';
import 'package:psychiatrist_project/model.dart/doctor_model.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  final String recieverName;

  ChatScreen({required this.chatRoom, required this.recieverName});

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

  String formatTime(String dateString)
  {
    // Parse the date string to DateTime
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime to the desired format with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    // Print the formatted time
    log(formattedTime); // Output: 09:28 PM
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.recieverName}'),  // Replace with the name of the other participant
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('personalChats').doc(widget.chatRoom.chatId)
                  .collection('message')
                  // .where('chatId', isEqualTo: widget.chatRoom.chatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                else if(snapshot.data!.docs.length == 0)
                  {
                    return Center(child: Text("Say Hi"));
                  }
                else{
                  log(widget.chatRoom.chatId);
                  log(snapshot.data!.docs.length.toString());
                  return ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var message = ChatMessage.fromDocument(snapshot.data!.docs[index]);
                      log("Time: ${message.timestamp.toDate().toString()}");
                      bool isCurrentUser = message.senderId == authController.currentUserId; // Check if the message is from the current user

                      return Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: isCurrentUser ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatTime(message.timestamp.toDate().toString()), // Format your timestamp
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isCurrentUser ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      // return ListTile(
                      //   title: Text(message.senderName),
                      //   subtitle: Text(message.message),
                      //   trailing: Text(formatTime(message.timestamp.toDate().toString())),
                      // );
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
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
