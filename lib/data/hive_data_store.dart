import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/hive_task.dart';
import 'package:hive_flutter/hive_flutter.dart';

// crud operation method forr hive db
class HiveDataStore {
  // box name - string
  static const boxName = 'taskBox';

  // our current box with all the saved data inside - box<task>
  final Box<hiveTask> box = Hive.box<hiveTask>(boxName);

  // add new task to box
  Future<void> addTask({required hiveTask task}) async {
    await box.put(task.id, task);
  }

  // show task
  Future<hiveTask?> getTask({required String id}) async {
    return box.get(id);
  }

  // update task
  Future<void> updateTask({required hiveTask task}) async {
    await task.save();
  }

  // delete task
  Future<void> deleteTask({required hiveTask task}) async {
    await task.delete();
  }

  // listen to box changes
  // using yhis method we will listen to box changes and update the ui accordingly
  ValueListenable<Box<hiveTask>> listenToTask() => box.listenable();
}