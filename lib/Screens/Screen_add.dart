import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:week8/Db/functions/db_functions.dart';
import 'package:week8/Db/model/db_models.dart';

XFile? images;

class ScreenAdd extends StatefulWidget {
  ScreenAdd({super.key});

  @override
  State<ScreenAdd> createState() => _ScreenAddState();
}

class _ScreenAddState extends State<ScreenAdd> {
  final NameFromField = TextEditingController();

  final AgeFromField = TextEditingController();

  final MobileFromField = TextEditingController();

  final locationFormField = TextEditingController();

  final _FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  selectionImage(context);
                },
                child: Container(
                    height: 150,
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    )),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter your name';
                  } else {
                    return null;
                  }
                },
                controller: NameFromField,
                decoration: const InputDecoration(
                    hintText: 'Name',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your age';
                    } else if (int.parse(value) > 100 ||
                        int.parse(value) < 18) {
                      return 'please enter valid age';
                    } else {
                      return null;
                    }
                  },
                  controller: AgeFromField,
                  decoration: const InputDecoration(
                      hintText: 'Age',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  RegExp regExp = RegExp(pattern);
                  if (value == null || value.isEmpty || value.length != 10) {
                    return 'Please enter mobile number';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Please enter valid mobile number';
                  }
                  return null;
                },
                controller: MobileFromField,
                decoration: const InputDecoration(
                    hintText: 'Phone',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextFormField(
                  controller: locationFormField,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please add your location';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: 'location',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      images = null;
                      selectionImage(context);
                    },
                    icon: const Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    if (_FormKey.currentState!.validate()) {
                      addDATA(context);
                    }
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                  ),
                  label: const Text(
                    'add student',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
            ],
          ),
        ),
      ),
    ]);
  }

  selectionImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        width: double.infinity,
        child: Column(
          children: [
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                images = await pickImage(ImageSource.camera);
              },
              leading: IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    images = await pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_enhance)),
              title: const Text('Camera'),
            ),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                images = await pickImage(ImageSource.gallery);
              },
              leading: IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    images = await pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo)),
              title: const Text('Gallery'),
            ),
          ],
        ),
      ),
    );
  }

  Future addDATA(context) async {
    final name = NameFromField.text;
    final age = AgeFromField.text.trim();
    final phone = MobileFromField.text.trim();
    final location = locationFormField.text.trim();
    if (name.isEmpty || age.isEmpty || phone.isEmpty || location.isEmpty) {
      return;
    } else if (images == null) {
      snak();
    } else {
      _FormKey.currentState!.reset();
      final student = StudentModel(
          name: name,
          age: age,
          phone: phone,
          image: images!.path,
          location: location);
      addStudent(student);

      images = null;

      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                actions: [
                  Align(
                      child: Image.asset(
                          'assets/images/1818-success-animation.gif'),
                      alignment: Alignment.center),
                ],
              ));
    }
  }

  snak() {
    const snakber = SnackBar(
      content: Text('Upload image and continue'),
      margin: EdgeInsets.all(30),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snakber,
    );
  }

  Future<XFile?> pickImage(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource);
    return image;
  }
}
