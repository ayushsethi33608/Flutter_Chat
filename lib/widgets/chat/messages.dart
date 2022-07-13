import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  Messages(this.receiverID);
  final String receiverID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> chatsnapshot) {
          if (chatsnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final userdetails = FirebaseAuth.instance.currentUser!.uid;
          final chatDocs = chatsnapshot.data!.docs
              .where((element) =>
                  element.get('userID') == userdetails &&
                      element.get('receiverID') == receiverID ||
                  element.get('userID') == receiverID &&
                      element.get('receiverID') == userdetails)
              .toList();

          return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  chatDocs.elementAt(index).get('text'),
                  chatDocs.elementAt(index).get('userID') ==
                      FirebaseAuth.instance.currentUser!.uid,
                  chatDocs.elementAt(index).get('username'),
                  chatDocs.elementAt(index).get('userImage'),
                  key: ValueKey(chatDocs.elementAt(index).id),
                );
              });
        });
  }
}
