import 'package:flutter/material.dart';

class Task {
  bool _isTaskCompleted;
  String _taskDetails;


  Task(taskDetails, isTaskCompleted){
    this._isTaskCompleted = isTaskCompleted;
    this._taskDetails = taskDetails;
  }


  bool isCompleted() => _isTaskCompleted;

  void setIsCompleted(bool val) {
    _isTaskCompleted = val;
  }

  set taskDetails(String val) {
    this._taskDetails = val;
  }

Map<String, dynamic> toMap() {
    return {
      'detail': this._taskDetails,
      'isCompleted': _isTaskCompleted ?? false,
    };
  }

  String getTaskDetails() => _taskDetails;

}
