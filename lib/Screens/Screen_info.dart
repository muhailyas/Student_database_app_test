import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:week8/Screens/Screen_List.dart';

class ScreenInfo extends StatelessWidget {
  const ScreenInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'STUDENT RECORD',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(File(Student.image)),
                        fit: BoxFit.cover)),
              ),
            ),
            Text(
              "NAME : ${Student.name}",
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia'),
            ),
            Text(
              "AGE : ${Student.age}",
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia'),
            ),
            Text(
              "PHONE : ${Student.phone}",
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia'),
            ),
            Text(
              "LOCATION : ${Student.location}",
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia'),
            ),
          ],
        ),
      ),
    );
  }

  Future<XFile?> updateImage() async {
    final imagx = await ImagePicker().pickImage(source: ImageSource.gallery);
    return imagx;
  }
}
