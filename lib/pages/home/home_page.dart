import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/hive_task.dart';
import 'package:todo_app/pages/home/home_page_appbar.dart';
import 'package:todo_app/pages/drawer/slider_drawer.dart';
import 'package:todo_app/pages/home/task_widget.dart';
import 'package:todo_app/pages/tasks_detail/task_view.dart';
import 'package:todo_app/utility/dialog_box.dart';
import 'package:todo_app/utility/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();
  bool _showSortOptions = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  Set<String> _selectedFilters = {}; 


  @override
  void initState() {
      super.initState();
      _controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }
  // check value of circle indicator
  dynamic valueOfIndicator(List<hiveTask> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  // check done tasks
  int checkDoneTask(List<hiveTask> tasks) {
    int i = 0;
    for (hiveTask doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);
    String todayDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
    builder: (ctx, Box<hiveTask> box, Widget? child) {
      var tasks = box.values.toList();

      tasks = tasks.where((task) {
        if (_selectedFilters.contains('Daily Task') && task.category != 'daily') {
          return false;
        }
        if (_selectedFilters.contains('Priority Task') && task.category != 'priority') {
          return false;
        }
        if (_selectedFilters.contains('Today Task')) {
          DateTime today = DateTime.now();
          today = DateTime(today.year, today.month, today.day); 
          if (!(task.startAtDate.compareTo(today) <= 0 && task.endAtDate.compareTo(today) >= 0)) {
            return false;
          }
        }

        return true;
      }).toList();

      // Sort tasks if needed
      tasks.sort((a, b) => a.endAtDate.compareTo(b.endAtDate));
        return Scaffold(
          backgroundColor: Colors.white,
          // floating action button
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => const TaskView(
                    titleTaskController: null,
                    descriptionTaskController: null,
                    task: null,
                  ),
                ),
              );
            },
            child: FloatingActionButton(
              elevation: 10,
              onPressed: null,
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
          ),

          body: SliderDrawer(
            key: drawerKey,
            isDraggable: false,
            animationDuration: 300,

            // drawer
            slider: CustomDrawer(),

            appBar: HomeAppBar(
              drawerKey: drawerKey,
            ),

            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      todayDate,
                      style: textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: double.infinity,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            value:
                                checkDoneTask(tasks) / valueOfIndicator(tasks),
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
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
                              "${checkDoneTask(tasks)} of ${tasks.length} task",
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

                  // Filter section
                 Container(
                  
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: SingleChildScrollView (
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                      children: [

                        Wrap(
                          spacing: 8.0, 
                          children: [
                            FilterChip(
                              label: Container(child: Text('Today Task')),
                              selected: _selectedFilters.contains('Today Task'),
                              showCheckmark: false,
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    _selectedFilters.add('Today Task');
                                  } else {
                                    _selectedFilters.remove('Today Task');
                                  }
                                });
                              },
                            ),
                            FilterChip(
                              label: Text('Priority Task'),
                              selected: _selectedFilters.contains('Priority Task'),
                              showCheckmark: false,
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    _selectedFilters.add('Priority Task');
                                  } else {
                                    _selectedFilters.remove('Priority Task');
                                  }
                                });
                              },
                            ),
                            FilterChip(
                              label: Text('Daily Task'),
                              selected: _selectedFilters.contains('Daily Task'),
                              showCheckmark: false,
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    _selectedFilters.add('Daily Task');
                                  } else {
                                    _selectedFilters.remove('Daily Task');
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                   ),
                 ),
                  // tasks
                  Expanded(
                    child: tasks.isNotEmpty
                        ? ListView.builder(
                            itemCount: tasks.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              // get single task for showing in list
                              var task = tasks[index];
                              return Dismissible(
                                  direction: DismissDirection.horizontal,
                                  key: Key(task.id.toString()),
                                  onDismissed: (_) {
                                    base.dataStore
                                        .deleteTask(task: task)
                                        .then((_) {
                                      setState(() {
                                        tasks.removeAt(index);
                                      });
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
                                  child: TaskWidget(
                                    task: task,
                                  ));
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
      },
    );
  }
}
