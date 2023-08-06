import 'package:hive/hive.dart';
part 'db_models.g.dart';

@HiveType(typeId: 1)
class StudentModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String age;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String image;

  @HiveField(5)
  String location;

  StudentModel(
      {
      this.id,
      required this.image,
      required this.name,
      required this.age,
      required this.phone,
      required this.location});
}
