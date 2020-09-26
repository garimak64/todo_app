import 'package:todoapp/model/task.dart';

class Note {

  String _title;
  List<Task> _tasks;

  Note(String title, List<Task> tasks){
    this._title = title;
    this._tasks = tasks;
  }
  
}
