import 'dart:io';

import 'package:flutter/material.dart';
import 'package:week8/Db/functions/db_functions.dart';
import 'package:week8/Screens/Screen_info.dart';
import '../Db/model/db_models.dart';

// ignore: non_constant_identifier_names
late StudentModel Student;
TextEditingController searchcontroller = TextEditingController();
TextEditingController nameField = TextEditingController();
TextEditingController ageField = TextEditingController();
TextEditingController phoneField = TextEditingController();
bool isListEmpty = true;

final formkey = GlobalKey<FormState>();

class ScreenListDetails extends StatelessWidget {
  ScreenListDetails({super.key});

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: searchcontroller,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: 'Search ....',
            hintStyle: const TextStyle(color: Colors.black),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                searchAndUpdateStudents(searchcontroller.text);
              },
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: studentListNotifier,
          builder: (BuildContext ctx, List<StudentModel> studentList, child) {
            isListEmpty = studentList.isEmpty;
            return isListEmpty
                ? const Center(
                    child: Text('list is empty'),
                  )
                : ListView.separated(
                    itemBuilder: (context1, index) {
                      var data = studentList[index];
                      return Card(
                        color: Colors.white60,
                        child: ListTile(
                          onTap: () {
                            Student = StudentModel(
                                name: data.name,
                                age: data.age,
                                phone: data.phone,
                                image: data.image,
                                location: data.location);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx1) => ScreenInfo()));
                          },
                          leading: CircleAvatar(
                            backgroundImage: FileImage(File(data.image)),
                            radius: 30,
                          ),
                          title: Text(data.name),
                          subtitle: Text(data.age),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    editField(context1, studentList[index]);
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: const Text('Delete'),
                                            content: const Text(
                                                'are you sure you want to delete'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  deleteStudent(data);
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Text('Yes'),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Text('No'),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: studentList.length);
          }),
    );
  }

  void editField(ctx2, StudentModel student) {
    nameField = TextEditingController(text: student.name);
    ageField = TextEditingController(text: student.age);
    phoneField = TextEditingController(text: student.phone);
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx2,
        builder: (ctx1) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx1).viewInsets.bottom),
              child: Container(
                height: 330,
                width: double.infinity,
                color: Colors.white38,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Form(
                    key: formkey,
                    child: ListView(children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter name';
                          } else {
                            return null;
                          }
                        },
                        controller: nameField,
                        decoration: InputDecoration(
                            hintText: 'name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      TextFormField(
                        controller: ageField,
                        validator: (value) {
                          if (value == null ||
                              int.parse(value) < 0 ||
                              int.parse(value) > 100) {
                            return 'enter valid age';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'age',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.length != 10) {
                            return 'enter valid number';
                          } else {
                            return null;
                          }
                        },
                        controller: phoneField,
                        decoration: InputDecoration(
                            hintText: 'phone',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            editOne(ctx1, student);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        icon: Icon(Icons.cloud_upload_sharp),
                        label: Text('save changes '),
                      ),
                    ]),
                  ),
                ),
              ),
            ));
  }

  editOne(context, student) {
    final n = nameField.text;
    final a = ageField.text;
    final p = phoneField.text;

    if (n.isEmpty || a.isEmpty || p.isEmpty) {
      return;
    } else {
      Navigator.of(context).pop();
      editstudent(
        studentModel: student,
        name: nameField.text,
        age: ageField.text,
        phone: phoneField.text,
      );
    }
  }
}
