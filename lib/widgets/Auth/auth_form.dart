import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/Pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.is_loading);
  final bool is_loading;
  final void Function(String email, String password, String username,
      File? image, bool isLogin, BuildContext ctx) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var isLogin = true;
  var userEmail = "";
  var userName = "";
  var userPassword = "";
  File? _userImageFile;

  void _pickedImage(File? image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    // if (_userImageFile == null && !isLogin) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Please pick an image......'),
    //     backgroundColor: Theme.of(context).errorColor,
    //   ));
    // }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(userEmail.trim(), userPassword.trim(), userName.trim(),
          _userImageFile, isLogin, context);
      print(userEmail);
      print(userName);
      print(userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userEmail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email ID ",
                  ),
                ),
                if (!isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return "Please enter a valid username";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userName = value!;
                    },
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return "Please enter a valid password ";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userPassword = value!;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.is_loading) CircularProgressIndicator(),
                if (!widget.is_loading)
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _trySubmit();
                    },
                    child: Text(isLogin ? "Login" : "SignUp"),
                  ),
                if (!widget.is_loading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(isLogin
                        ? "Create New Account"
                        : "I already have an account."),
                  ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
