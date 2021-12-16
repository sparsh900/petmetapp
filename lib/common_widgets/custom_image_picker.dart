import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmet_app/main.dart';

class CustomImagePicker {
  static Future<File> show(BuildContext context) async {
    File image;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Choose Image Source',
            textAlign: TextAlign.center,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 18,
                    color: petColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  final _pickedFile =
                  await ImagePicker().getImage(source: ImageSource.gallery);
                  Navigator.of(context).pop();
                  image = File(_pickedFile.path);
                },
              ),
              FlatButton(
                child: Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 18,
                    color: petColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  final _pickedFile =
                  await ImagePicker().getImage(source: ImageSource.camera);
                  Navigator.of(context).pop();
                  image = File(_pickedFile.path);
                },
              )
            ],
          ),
        );
      },
    );
    return image;
  }
}
