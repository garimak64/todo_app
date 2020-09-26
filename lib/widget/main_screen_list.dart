import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:todoapp/model/task.dart';
import 'package:todoapp/screen/second_screen.dart';
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
                      return InkWell(
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
                                  builder: (context) => 
                                  SecondRoute(
                                    title: title,
                                    documentID: data.docs[index].id,
                                  )),
                            );
                          },
                          child: Container(
                              child: Text(title,
                            style: TextStyle(fontSize: 20.0),
                          )));
                    });
  }
}
