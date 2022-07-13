import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage(this.receiverID);
  final String receiverID;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  @override
  var _enteredmessage = '';
  final _controller = new TextEditingController();

  void _sendmessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userdata = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredmessage,
      'createdAt': Timestamp.now(),
      'userID': user.uid,
      'username': userdata['username'],
      'userImage': userdata['image_url'],
      'receiverID': widget.receiverID,
    });
    _controller.clear();
    setState(() {
      _enteredmessage = "";
    });
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _enteredmessage = value.trim();
                });
              },
              decoration: InputDecoration(labelText: "Send a message......"),
            ),
          ),
          IconButton(
            onPressed: _enteredmessage.trim().isEmpty
                ? null
                : () {
                    _sendmessage();
                  },
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
