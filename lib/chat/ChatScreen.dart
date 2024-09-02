import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:psychiatrist_project/chat/ChatMessage.dart';
import 'package:psychiatrist_project/chat/ChatRoomModel.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  ChatScreen({required this.chatRoom});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('messages').add({
        'chatId': widget.chatRoom.chatId,
        'senderId': 'current_user_id', // Replace with current user ID
        'senderName': 'current_user_name', // Replace with current user name
        'message': _messageController.text,
        'timestamp': Timestamp.now(),
      });

      FirebaseFirestore.instance.collection('chatRooms').doc(widget.chatRoom.chatId).update({
        'lastMessage': _messageController.text,
        'lastMessageTime': Timestamp.now(),
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.chatRoom.chatId}'),  // Replace with the name of the other participant
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chatId', isEqualTo: widget.chatRoom.chatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = ChatMessage.fromDocument(snapshot.data!.docs[index]);
                    return ListTile(
                      title: Text(message.senderName),
                      subtitle: Text(message.message),
                      trailing: Text(message.timestamp.toDate().toString()),
                    );
                  },
                );
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
