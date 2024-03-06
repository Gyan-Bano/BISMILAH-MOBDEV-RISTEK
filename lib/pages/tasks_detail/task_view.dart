import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/hive_task.dart';
import 'package:todo_app/pages/tasks_detail/date_time_selection.dart';
import 'package:todo_app/pages/tasks_detail/rep_textfield.dart';
import 'package:todo_app/pages/tasks_detail/task_view_appbar.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {super.key,
      required this.titleTaskController,
      required this.descriptionTaskController,
      required this.task});

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final hiveTask? task;
  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      selectedCategory = widget.task!.category;
    }
  }

  // show selected date as string format
  String showStartDate(DateTime? date) {
    if (widget.task?.startAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.startAtDate).toString();
    }
  }

  String showEndDate(DateTime? date) {
    if (widget.task?.endAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.endAtDate).toString();
    }
  }

  // show selected date as date format for init time
  DateTime showStartDateAsDateTime(DateTime? date) {
    if (widget.task?.startAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.startAtDate;
    }
  }

  DateTime showEndDateAsDateTime(DateTime? date) {
    if (widget.task?.endAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.endAtDate;
    }
  }

  bool isTaskAlreadyExsist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  // function for creating and updating task
  dynamic isAlreadyExsistUpdateOtherwiseCreate() {
    try {
      if (widget.task != null) {
        String? updatedTitle = title;
        String? updatedSubTitle = subTitle;
        String? updatedSelectedCategory = selectedCategory;

        if (updatedTitle != null && updatedTitle != widget.task!.title) {
          widget.task!.title = updatedTitle;
        }

        if (updatedSubTitle != null &&
            updatedSubTitle != widget.task!.subTitle) {
          widget.task!.subTitle = updatedSubTitle;
        }

        if (updatedSelectedCategory != null &&
            updatedSelectedCategory != widget.task!.category) {
          widget.task!.category = updatedSelectedCategory;
        }

        widget.task!.save();

        Navigator.pop(context);
      } else {
        if (title != null && subTitle != null) {
          var task = hiveTask.create(
            title: title,
            subTitle: subTitle,
            startAtDate: startDate,
            endAtDate: endDate,
            category: selectedCategory,
          );

          BaseWidget.of(context).dataStore.addTask(task: task);

          Navigator.pop(context);
        } else {
          print("Cannot be empty");
          // Warning
          // TODO: Handle empty fields case
        }
      }
    } catch (e) {
      // Handle any exceptions that occur during the update process
      print('An error occurred while updating the task: $e');
      // Optionally, show an error message to the user
    }
  }

  // delete task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
Widget build(BuildContext context) {
 var textTheme = Theme.of(context).textTheme;
 return GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
    child: Scaffold(
      appBar: const TaskViewAppBar(),
      
      body: SingleChildScrollView( // This makes the entire content scrollable
        child: Column(
          children: [
            _buildTopSideTexts(textTheme),
            _buildMainTaskViewActivity(textTheme, context),
          ],
        ),
      ),
    ),
 );
}


  
  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "What are you planning?",
                style: textTheme.bodyMedium,
              ),
            ),
        
            // task title
            RepTextField(
              controller: widget.titleTaskController,
              onChanged: (String inputTitle) {
                title = inputTitle;
              },
              onFieldSubmitted: (String inputTitle) {
                title = inputTitle;
              },
            ),
        
            const SizedBox(
              height: 10,
            ),
        
            // task description
            RepTextField(
              controller: widget.descriptionTaskController,
              isForDescription: true,
              onChanged: (String inputSubTitle) {
                subTitle = inputSubTitle;
              },
              onFieldSubmitted: (String inputSubTitle) {
                subTitle = inputSubTitle;
              },
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = 'priority';
                          });
                        },
                        minWidth: 150,
                        child: Text(
                          'Priority Tasks',
                          style: TextStyle(
                            color: selectedCategory == 'priority'
                                ? Colors.white
                                : Colors.purple,
                          ),
                        ),
                        color: selectedCategory == 'priority'
                            ? Colors.purple
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 55,
                        elevation: .5,
                      ),
                      SizedBox(width: 5), // Fixed distance between buttons
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = 'daily';
                          });
                        },
                        minWidth: 150,
                        child: Text(
                          'Daily Tasks',
                          style: TextStyle(
                            color: selectedCategory == 'daily'
                                ? Colors.white
                                : Colors.purple,
                          ),
                        ),
                        color: selectedCategory == 'daily'
                            ? Colors.purple
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 55,
                        elevation: .5,
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
            // date selector
            DateTimeSelectionWidget(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  minDateTime: DateTime.now(),
                  initialDateTime: showStartDateAsDateTime(startDate),
                  onConfirm: (dateTime, _) {
                    setState(() {
                      if (widget.task?.startAtDate == null) {
                        startDate = dateTime;
                        endDate = startDate;
                      } else {
                        widget.task!.startAtDate = dateTime;
                        widget.task!.endAtDate = dateTime;
                      }
                    });
                  },
                );
              },
              title: 'Start',
              date: showStartDate(startDate),
            ),
        
            // date selector
            DateTimeSelectionWidget(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  minDateTime: startDate ?? DateTime.now(),
                  initialDateTime: showEndDateAsDateTime(endDate),
                  onConfirm: (dateTime, _) {
                    setState(() {
                      if (widget.task?.endAtDate == null) {
                        endDate = dateTime;
                      } else {
                        widget.task!.endAtDate = dateTime;
                      }
                    });
                  },
                );
              },
              title: 'Ends',
              date: showEndDate(endDate),
            ),
        
            Container(
              margin: const EdgeInsets.only(top: 75),
              child: Row(
                mainAxisAlignment: isTaskAlreadyExsist()
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceEvenly,
                children: [
                  isTaskAlreadyExsist()
                      ? Container()
                      :
                      // delete current task button
                      MaterialButton(
                          onPressed: () {
                            deleteTask();
                            Navigator.pop(context);
                          },
                          minWidth: 150,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 55,
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.trash_fill,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Delete Task",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
              
                  // add or update task
                  MaterialButton(
                    onPressed: () {
                      isAlreadyExsistUpdateOtherwiseCreate();
                    },
                    minWidth: 150,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 55,
                    child: Text(
                      isTaskAlreadyExsist() ? "Add Task" : "Update Task",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
              text: TextSpan(
            text: isTaskAlreadyExsist() ? "Add New " : "Update ",
            style: textTheme.titleLarge,
            children: const [
              TextSpan(
                  text: "Task", style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          )),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
