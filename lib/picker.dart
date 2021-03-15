import 'dart:io';

import 'package:drag/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Picker extends StatefulWidget {
  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  File _video;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _video == null
              ? Text('No video selected.')
              : Text(' video selected.'),
          TextButton(onPressed: getImage, child: Icon(Icons.add_a_photo))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_video == null) {
            return;
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(
                        video: _video,
                      )));
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
