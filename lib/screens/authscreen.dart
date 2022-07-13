import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/Auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _is_Loading = false;

  void _submitAuthForm(String email, String password, String username,
      File? image, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _is_Loading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + ".jpg");
        var url;

        if (image != null) {
          await ref.putFile(image).whenComplete(() => null);
          url = await ref.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': image == null
              ? "https://firebasestorage.googleapis.com/v0/b/flutterchat-f0ff0.appspot.com/o/user_image%2Fdefaultdp.jpg?alt=media&token=628125fe-fa71-4fc6-8070-9c9dfc2f2bf2"
              : url,
          'user_id': authResult.user!.uid, // New line added
        });
      }
    } on FirebaseAuthException catch (err) {
      setState(() {
        _is_Loading = false;
      });

      var message = "An error occured , please check the credentials";

      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (er) {
      setState(() {
        _is_Loading = false;
      });
      print("helooo");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _is_Loading),
    );
  }
}
