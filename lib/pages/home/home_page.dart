import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/pages/home/home_page_appbar.dart';
import 'package:todo_app/pages/home/slider_drawer.dart';
import 'package:todo_app/pages/home/task_widget.dart';
import 'package:todo_app/utility/dialog_box.dart';
import 'package:todo_app/utility/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();
  final List<int> testing = [222];

  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get("TODOLIST") == null) {
      db.toDoList = [];
    } else {
      db.loadData();
    }
    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
    db.updateDataBase();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: createNewTask,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SliderDrawer(
        key: drawerKey,
        isDraggable: false,
        animationDuration: 500,

        // drawer 
        slider: CustomDrawer(),
        appBar: HomeAppBar(drawerKey: drawerKey,),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              // custom app bar
              Container(
                margin: const EdgeInsets.only(top: 60),
                width: double.infinity,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          value: 1 / 3,
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor,
                          ),
                        )),
                    // space
                    SizedBox(width: 25),

                    // top level task info
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Tasks",
                          style: textTheme.displayLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "1 of 3 task",
                          style: textTheme.titleMedium,
                        )
                      ],
                    )
                  ],
                ),
              ),

              // divider
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Divider(
                  thickness: 2,
                  indent: 100,
                ),
              ),

              // tasks
              Expanded(
                child: testing.isNotEmpty
                    ? ListView.builder(
                        itemCount: testing.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Dismissible(
                              direction: DismissDirection.horizontal,
                              onDismissed: (direction) {
                                setState(() {
                                  testing.removeAt(index);
                                });
                              },
                              background: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "This task was deleted",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              key: Key(
                                index.toString(),
                              ),
                              child: const TaskWidget());
                        })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeInUp(
                            from: 30,
                            child: const Text("You have done all tasks!"),
                          ),
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
