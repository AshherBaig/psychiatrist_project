import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:psychiatrist_project/chat/model/ChatRoomModel.dart';
import 'package:psychiatrist_project/chat/screens/ChatScreen.dart';

class ChatRoomListScreen extends StatelessWidget {
  final String userId;

  String convertTimestampToReadableTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  ChatRoomListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    log("userId: $userId");
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        backgroundColor: Colors.teal, // Changed color for better aesthetics
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('personalChats')
            .where('participantIds', arrayContains: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.teal, // Matching app bar color
              ),
            );
          } else {
            if (snapshot.data!.docs.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var chatRoom =
                  ChatRoom.fromDocument(snapshot.data!.docs[index]);
                  var otherParticipant = chatRoom.participants
                      .firstWhere((p) => p['userId'] != userId);
                  log("Other Participant: ${otherParticipant.toString()}");
                  bool isCurrentUser = otherParticipant['userId'] == userId;

                  return InkWell(
                    onTap: () {
                      log(otherParticipant['userName']);
                      log(otherParticipant['userId']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            isDoctor: true,
                            chatRoom: chatRoom,
                            recieverName:
                            otherParticipant['userName'] ?? 'Unknown',
                            recieverId: otherParticipant['userId'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24.0,
                              backgroundColor: Colors.grey[300],
                              child: Text(
                                (otherParticipant['userName'] ??
                                    'U')[0], // Display initial
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    otherParticipant['userName'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    chatRoom.lastMessage,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              convertTimestampToReadableTime(
                                  chatRoom.lastMessageTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No Chat Available",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700])),
              );
            }
          }
        },
      ),
    );
  }
}