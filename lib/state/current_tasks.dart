import 'package:flutter/material.dart';
import 'package:todoapp/model/task.dart';

class CurrentTasks extends ChangeNotifier {
  List<Task> _tasks;

  void setNewTask(Task task) { 
    _tasks.add(task);
    notifyListeners();
  }

  void clear() {
    _tasks = [];
  }

  void setCurrentTasks(List<Task> tasks) {
    this._tasks = tasks;
    notifyListeners();
  }


  List<Task> getTasks() => _tasks;
}
