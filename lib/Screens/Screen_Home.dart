// ignore: file_names
import 'package:flutter/material.dart';
import 'Screen_List.dart';
import 'Screen_add.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int currentIndex = 0;
  List Bottom = [ScreenAdd(), ScreenListDetails()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'STUDENT RECORD',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Bottom[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedFontSize: 16,
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        iconSize: 30,
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          currentIndex = value;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'add '),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'info')
        ],
      ),
    );
  }
}
