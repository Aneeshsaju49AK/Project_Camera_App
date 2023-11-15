import 'dart:io';

import 'data_helper.dart';
import 'package:flutter/material.dart';

import 'imageModel.dart';

class ScreenShowImages extends StatefulWidget {
  ScreenShowImages({super.key});

  @override
  State<ScreenShowImages> createState() => _ScreenShowImagesState();
}

class _ScreenShowImagesState extends State<ScreenShowImages> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Images> images = [];

  @override
  void initState() {
    _refreshImages();
    super.initState();
  }

  _refreshImages() async {
    final imageList = await databaseHelper.getImages();
    setState(() {
      images = imageList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Images'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.file(
                        File(image.imagePath),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      left: 80,
                      child: IconButton(
                        onPressed: () {
                          databaseHelper.deleteImage(image.id!);
                          _refreshImages();
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
