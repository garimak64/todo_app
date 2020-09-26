import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/dao/firestore_helper.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/state/current_tasks.dart';
import 'package:todoapp/widget/task_list_widget.dart';
import 'package:todoapp/widget/task_row_widget.dart';

class TodoScreen extends StatefulWidget {
  final String title;
  final String documentID;

  const TodoScreen({Key key, this.title, this.documentID})
      : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
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
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    FireStoreHelper.deleteRecord(widget.documentID);
                    Navigator.pop(context);
                  }),
            ],
            title: Text("T0-DO"),
          ),
          body: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,

                child: Padding(
                  padding: const EdgeInsets.only(left:10.0,top: 10),
                  child: TextField(
                    controller: titleCtrl,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22
                      )
                    ),
                    decoration: InputDecoration(
                      hintText: "Title..",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),


                    ),
                  ),
                ),
              ),
              Container(
                child: TaskListView(tasks),
              ),
            ],
          )),
    );
  }

  Future<bool> _onWillPop(CurrentTasks tasks) async {

    if(titleCtrl.text != null && titleCtrl.text.isEmpty) {
      titleCtrl.text = 'No Title';
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
