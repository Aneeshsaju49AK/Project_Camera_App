import 'dart:io';

import 'data_helper.dart';
import 'imageModel.dart';
import 'show_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScreenCamera extends StatefulWidget {
  final DatabaseHelper database = DatabaseHelper();
  ScreenCamera({super.key});

  @override
  State<ScreenCamera> createState() => _ScreenCameraState();
}

class _ScreenCameraState extends State<ScreenCamera> {
  String? _imagePath;
  XFile? _image;
  bool _isEmpty = false;

  @override
  void initState() {
    cameraRoll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       setState(() {
        //         _isEmpty = false;
        //       });
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (ctx) => ScreenShowImages(),
        //         ),
        //       );
        //     },
        //     icon: Icon(Icons.camera_sharp),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isEmpty = false;
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ScreenShowImages(),
                    ),
                  );
                },
                icon: Icon(Icons.camera_sharp),
              ),
            ),
            Center(
              child: Container(
                child: _isEmpty ? Image.file(File(_imagePath!)) : null,
              ),
            ),
            SizedBox(
              height: 553,
            ),
            Container(
              margin: EdgeInsets.only(right: 200),
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    _isEmpty = false;
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ScreenShowImages(),
                    ),
                  );
                },
                label: Text('Gallery'),
                icon: Icon(Icons.browse_gallery),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          cameraRoll();
        },
        icon: const Icon(Icons.camera_alt_outlined),
        label: Text(
          'New Image',
        ),
      ),
    );
  }

  void _navigateToGallery() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ScreenShowImages(),
      ),
    );
  }

  void _navigateBackToCamera() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => ScreenCamera(),
      ),
    );
  }

  cameraRoll() async {
    XFile? _img = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = _img;
    });
    _imagePath = _image!.path;
    if (_imagePath != null) {
      _isEmpty = true;
    }
    print(_isEmpty);
    final image = Images(
      id: 0,
      imagePath: _imagePath ?? '',
    );
    widget.database.addImage(image).then((id) {
      if (id > 0) {
        print('add image');
        _navigateBackToCamera(); // Navigate back to the camera screen
      } else {
        print('cant add image');
      }
    });
  }
}
