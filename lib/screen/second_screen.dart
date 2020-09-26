import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/dao/firestore.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/state/current_tasks.dart';
import 'package:todoapp/widget/task_row.dart';

class SecondRoute extends StatefulWidget {
  final String title;
  final String documentID;

  const SecondRoute({Key key, this.title, this.documentID}) : super(key: key);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final TextEditingController titleCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    titleCtrl.text = widget.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    CurrentTasks currentTasks = Provider.of<CurrentTasks>(context);
    List<Task> tasks = currentTasks.getTasks();

    return WillPopScope(
      onWillPop: () => _onWillPop(currentTasks),
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    FireStoreHelper.deleteRecord(widget.documentID);
                    Navigator.pop(context);
                  }),
            ],
            title: Text("TO-DO"),
          ),
          body: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20, right: 10),
                  child: TextFormField(
                    controller: titleCtrl,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      hintText: "Title..",

                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 360,
                child: Padding(
                  padding:
                      const EdgeInsets.only( top: 20, right: 5),
                  child: ReorderableListView(
                    onReorder: currentTasks.reOrder,

                      children: tasks.map((element) => TaskRow(
                          task: element, key: ValueKey(element))).toList(),
                ),
              ),),
            ],
          )),
    );
  }

  Future<bool> _onWillPop(CurrentTasks tasks) {
    if (titleCtrl.text != null && titleCtrl.text.isEmpty) {
      titleCtrl.text = 'No title';
    }
    if (widget.documentID == null) {
      FireStoreHelper.createRecord(titleCtrl.text, tasks.getTasks());
    } else {
      FireStoreHelper.updateRecord(
          titleCtrl.text, tasks.getTasks(), widget.documentID);
    }
    tasks.clear();

    return Future.value(true);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    super.dispose();
  }
}
