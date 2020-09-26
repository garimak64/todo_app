import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/state/current_tasks.dart';

class TaskRow extends StatefulWidget {
  final Task task;

  TaskRow({Key key, this.task}) : super(key: key);

  @override
  _TaskRowState createState() => _TaskRowState(task, key);
}

class _TaskRowState extends State<TaskRow> {
  Task task;
  Key key;
  final TextEditingController _controller = new TextEditingController();

  _TaskRowState(Task task, Key key) {
    this.task = task;
    this.key = key;
  }

  @override
  void initState() {
    super.initState();
    _controller.text = task.getTaskDetails() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    CurrentTasks currentTasks =
        Provider.of<CurrentTasks>(context, listen: false);
    return CheckboxListTile(
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.leading,
      key: key,
      title: TextFormField(
        textInputAction: TextInputAction.go,
        keyboardType: TextInputType.text,
        controller: _controller,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "What to-do??",
        ),
        onChanged: (value) => task.taskDetails = value,
        onFieldSubmitted: (val) {
          task.taskDetails = val;
          if (val.isNotEmpty &&
              currentTasks
                  .getTasks()[currentTasks.getTasks().length - 1]
                  .getTaskDetails()
                  .isNotEmpty) {
            currentTasks.setNewTask(Task('', false));
          }
        },
        style: _getTextStyle(
          task.isCompleted(),
        ),
      ),
      onChanged: (bool value) {
        if (task.getTaskDetails().isNotEmpty)
          setState(() => task.setIsCompleted(value));
      },
      value: task.isCompleted(),
    );
  }

  TextStyle _getTextStyle(bool completed) {
    return completed
        ? TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.lightGreenAccent,
            fontSize: 18.0)
        : TextStyle(color: Colors.white, fontSize: 18.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
