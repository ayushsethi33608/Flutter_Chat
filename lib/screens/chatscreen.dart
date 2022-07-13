import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/chat/messages.dart';
import 'package:flutter_chat/widgets/chat/newmessage.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(this.receiverID, this.username);
  final String receiverID;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: Messages(receiverID),
          ),
          NewMessage(receiverID),
        ],
      )),
      appBar: AppBar(
        title: Text(username),
      ),
    );
  }
}
