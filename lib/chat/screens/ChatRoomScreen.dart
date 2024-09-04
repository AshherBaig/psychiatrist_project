import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psychiatrist_project/chat/model/ChatRoomModel.dart';
import 'package:psychiatrist_project/chat/screens/ChatScreen.dart';

class ChatRoomListScreen extends StatelessWidget {
  final String userId;

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


                    return ListTile(
                      title: Text(otherParticipant['userName'] ?? 'Unknown'),
                      subtitle: Text(chatRoom.lastMessage),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(chatRoom: chatRoom,recieverName: "Patient",),
                          ),
                        );
                      },
                    );
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
