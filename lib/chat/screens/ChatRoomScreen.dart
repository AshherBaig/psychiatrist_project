import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:psychiatrist_project/chat/model/ChatRoomModel.dart';
import 'package:psychiatrist_project/chat/screens/ChatScreen.dart';

class ChatRoomListScreen extends StatelessWidget {
  final String userId;

  String convertTimestampToReadableTime(Timestamp timestamp) {
    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime to a readable string with AM/PM
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
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('personalChats')
            .where('participantIds', arrayContains: userId).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.black,));
          }
          else{
            if(snapshot.data!.docs.length != 0)
              {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var chatRoom = ChatRoom.fromDocument(snapshot.data!.docs[index]);
                    var otherParticipant = chatRoom.participants.firstWhere((p) => p['userId'] != userId,);
                    log("Other Participant: ${otherParticipant.toString()}");
                    bool isCurrentUser = otherParticipant['userId'] == userId; // Check if the message is from the current user


                    return InkWell(
                      onTap: () {
                        log(otherParticipant['userName']);
                        log(otherParticipant['userId']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(chatRoom: chatRoom,recieverName: otherParticipant['userName'] ?? 'Unknown',
                            recieverId: otherParticipant['userId'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Row(
                          children: [
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
                            Text(
                              convertTimestampToReadableTime(chatRoom.lastMessageTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    //   ListTile(
                    //   title: Text(otherParticipant['userName'] ?? 'Unknown'),
                    //   subtitle: Text(chatRoom.lastMessage),
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => ChatScreen(chatRoom: chatRoom,recieverName: "Patient",),
                    //       ),
                    //     );
                    //   },
                    // );
                  },
                );
              }
            else{
              return Center(child: Text("Not Chat Available"),);
            }

          }
        },
      ),
    );
  }
}
