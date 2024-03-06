import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'hive_task.g.dart';

@HiveType(typeId: 0)
// ignore: camel_case_types
class hiveTask extends HiveObject {
  hiveTask({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.startAtDate,
    required this.endAtDate,
    required this.isCompleted, 
    required this.category,
  });

  @HiveField(0) // id
  final String id;
  @HiveField(1) // title
  String title;
  @HiveField(2) // subtitle
  String subTitle;
  @HiveField(3) // start date
  DateTime startAtDate;
  @HiveField(4) // end date
  DateTime endAtDate;
  @HiveField(5) // is completed
  bool isCompleted;
  @HiveField(6)
  String category; // Changed from comma to semicolon

  // create new task
  factory hiveTask.create({
    required String? title,
    required String? subTitle,
    DateTime? startAtDate,
    DateTime? endAtDate,
    required String? category,
  }) =>
      hiveTask(
        id: const Uuid().v1(),
        title: title ?? "",
        subTitle: subTitle ?? "",
        startAtDate: startAtDate ?? DateTime.now(),
        endAtDate: endAtDate ?? DateTime.now(),
        isCompleted: false,
        category: category ?? "",
      );
}
