import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting timestamps
import 'package:psychiatrist_project/community_chat/ComChatController.dart';
import 'package:psychiatrist_project/features/controllers/authController.dart';

class ComChatScreen extends StatelessWidget {
  final Comchatcontroller chatController = Get.put(Comchatcontroller());
  final TextEditingController messageController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    authController.fetchUserName(); // Fetch the user's name

    return Scaffold(
      appBar: AppBar(
        title: Text('Community Chat',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent, // Set a background color for the app bar
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final chatMessage = chatController.messages[index];
                  final isMe = chatMessage.senderId == authController.auth.currentUser?.uid;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                chatMessage.senderName,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              chatMessage.message,
                              style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            DateFormat('hh:mm a').format(chatMessage.timestamp.toDate()),
                            style: TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () {
                    final message = messageController.text.trim();
                    final senderName = authController.userName.value; // Get the user's name
                    final senderId = authController.auth.currentUser?.uid ?? 'Anonymous'; // Get the user ID
                    
                    if (message.isNotEmpty) {
                      chatController.sendMessage(message, senderId, senderName);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
