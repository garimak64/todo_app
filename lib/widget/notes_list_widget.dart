import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:todoapp/model/task.dart';
import 'package:todoapp/screen/todo_screen.dart';
import 'package:todoapp/state/current_tasks.dart';

class NotesList extends StatelessWidget {
  final QuerySnapshot data;
  final CurrentTasks currentTasks;
  const NotesList({
    Key key,
    this.data,
    this.currentTasks,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      final String title = data.docs[index].data()['title'];
                      return Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Container(
                            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                            child: makeListTile(data,index,currentTasks,title,context)),
                      );
                    });
  }

  ListTile makeListTile(QuerySnapshot data, int index, CurrentTasks currentTasks, String title,BuildContext context) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.event_note, color: Colors.white),
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    trailing:
    Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    onTap: () {
      List rawTasks = data.docs[index].data()['tasks'];
      List<Task> tasks = rawTasks.map((element) {
        String detail = element['detail'];
        bool isCompleted = element['isCompleted'];
        return Task(detail, isCompleted);
      }).toList();
      currentTasks.setCurrentTasks(tasks ?? []);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TodoScreen(
              title: title,
              documentID: data.docs[index].id,
            )),
      );
    },
  );


}
