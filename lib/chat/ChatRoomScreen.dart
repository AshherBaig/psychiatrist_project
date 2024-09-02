import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psychiatrist_project/chat/ChatRoomModel.dart';
import 'package:psychiatrist_project/chat/ChatScreen.dart';

class ChatRoomListScreen extends StatelessWidget {
  final String userId;

  ChatRoomListScreen({required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Rooms'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('participants', arrayContainsAny: [
              {'userId': userId}
            ])
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.black,));
          }
          else{
            log("object 1");
            if(snapshot.data!.docs.length != 0)
              {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    log("object 2");
                    var chatRoom = ChatRoom.fromDocument(snapshot.data!.docs[index]);
                    var otherParticipant = chatRoom.participants.firstWhere((p) => p['userId'] != userId,);
                    return ListTile(
                      title: Text(otherParticipant['userName'] ?? 'Unknown'),
                      subtitle: Text(chatRoom.lastMessage),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(chatRoom: chatRoom,),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            else{
              return Center(child: Text("No Chat Available"),);
            }

          }
        },
      ),
    );
  }
}
