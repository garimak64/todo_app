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

  void reOrder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Task item = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, item);
    notifyListeners();
  }
  
  int _indexOfKey(Key key) {
    return _tasks.indexWhere((Task d) => d.key == key);
  }

  bool reOrderNew(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _tasks[draggingIndex];
      debugPrint("Reordering $item -> $newPosition");
      _tasks.removeAt(draggingIndex);
      _tasks.insert(newPositionIndex, draggedItem);
      notifyListeners();
    return true;
  }

  List<Task> getTasks() => _tasks;
}
