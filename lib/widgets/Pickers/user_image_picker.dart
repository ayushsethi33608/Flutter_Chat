import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  @override
  File? _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
      }
    });
    widget.imagePickFn(_pickedImage!);
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: _pickedImage == null
                ? NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/flutterchat-f0ff0.appspot.com/o/user_image%2Fdefaultdp.jpg?alt=media&token=628125fe-fa71-4fc6-8070-9c9dfc2f2bf2")
                    as ImageProvider
                : FileImage(_pickedImage!)),
        TextButton.icon(
            onPressed: () => {_pickImage()},
            icon: Icon(Icons.image),
            label: Text('Add Widget')),
      ],
    );
  }
}
