import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:week8/Db/model/db_models.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

Future<void> addStudent(StudentModel value) async {
  final StudentDB = await Hive.openBox<StudentModel>('Student_data');
  final idx = await StudentDB.add(value);
  value.id = idx;
  print('add?');
  getAllStudents();
}

Future<void> getAllStudents() async {
  final StudentDB = await Hive.openBox<StudentModel>('Student_data');
  studentListNotifier.value.clear();
  studentListNotifier.value.addAll(StudentDB.values);
  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(StudentModel studentModel) async {
  final StudentDB = await Hive.openBox<StudentModel>('Student_data');
  studentModel.delete();
  getAllStudents();
}

Future<List<StudentModel>> searchData(String query) async {
  final StudentDB = await Hive.openBox<StudentModel>('Student_data');
  final allStudents = StudentDB.values.toList();

  if (query.isEmpty) {
    return allStudents;
  }

  final filteredStudents = allStudents.where((element) {
    final name = element.name.toLowerCase();
    final lowerQuery = query.toLowerCase();
    return name.contains(lowerQuery);
  }).toList();

  return filteredStudents;
}

Future<void> searchAndUpdateStudents(String query) async {
  final filteredStudents = await searchData(query);
  studentListNotifier.value = List.from(filteredStudents);
}

late StudentModel studentModel;
editstudent({
  required StudentModel studentModel,
  required String name,
  required String age,
  required String phone,
}) async {
  final StudentDB = await Hive.openBox<StudentModel>('Student_data');
  studentModel.name = name;
  studentModel.age = age;
  studentModel.phone = phone;
  studentModel.save();
  studentListNotifier.notifyListeners();
}
