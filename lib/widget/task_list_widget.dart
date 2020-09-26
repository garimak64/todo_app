import 'package:flutter/material.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/widget/task_row_widget.dart';


class TaskListView extends StatelessWidget {
  final List<Task> tasks;


  TaskListView(this.tasks);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return TaskRow(task: tasks[index], key: ValueKey(tasks[index]));
        });;
  }
}
