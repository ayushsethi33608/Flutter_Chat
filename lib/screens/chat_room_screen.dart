import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/chatscreen.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    const Text('Log out'),
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final currUser = FirebaseAuth.instance.currentUser;
            final users = snapshot.data!.docs
                .where((element) => element['user_id'] != currUser!.uid)
                .toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(users[index]['username']),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(users[index]['image_url']),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) {
                              return ChatScreen(users[index]['user_id'],
                                  users[index]['username']);
                            },
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          }),
    );
  }
}
