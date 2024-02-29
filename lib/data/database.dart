import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [["Make a Tutorial",]];
  // reference our box
  final _myBox = Hive.box('mybox');

  // load the data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
