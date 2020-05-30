import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

CameraWidget( context ) async {
  var image;
  await showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('Add Media'),
        content: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text('GALLERY'),
                  color: Colors.blue,
                  onPressed: () async {
                    image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
                    image = image.path;
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 10.0,),
              Expanded(
                child: RaisedButton(
                  child: Text('CAMERA'),
                  color: Colors.blue,
                  onPressed: () async {
                    image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
                    image = image.path;
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
  return image;
}