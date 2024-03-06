import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/hive_task.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/tasks_detail/task_view.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  final hiveTask task;
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubTitle =
      TextEditingController();

  @override
  void initState() {
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose();
    textEditingControllerForSubTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: () {
      // navigate to see task detail
        Navigator.push(
          context, 
          CupertinoPageRoute(
            builder: (ctx) => TaskView(
              titleTaskController: textEditingControllerForTitle,
              descriptionTaskController: textEditingControllerForSubTitle,
              task: widget.task,
            ),
          ),
        );
      },

      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: widget.task.isCompleted
                ? const Color(0xffede7fe)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 10)
            ]),
        duration: const Duration(milliseconds: 600),
        child: ListTile(
          // check icon
          leading: GestureDetector(
            onTap: () {
              // check uncheck
              widget.task.isCompleted = !widget.task.isCompleted;
              widget.task.save();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                color: widget.task.isCompleted
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: .8),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),

          // task title
          title: Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 5),
            child: Text(
              textEditingControllerForTitle.text,
              style: TextStyle(
                color: widget.task.isCompleted
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                fontWeight: FontWeight.w500,
                decoration:
                    widget.task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),

          // task detail
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textEditingControllerForSubTitle.text,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              // date of task
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Start: ${DateFormat.yMMMEd().format(widget.task.startAtDate)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.task.isCompleted
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      Text(
                        "Due: ${DateFormat.yMMMEd().format(widget.task.endAtDate)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.task.isCompleted
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
