import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/dao/firestore_helper.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/screen/todo_screen.dart';
import 'package:todoapp/state/current_tasks.dart';
import 'package:todoapp/widget/notes_list_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentTasks(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'TO-DO'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    CurrentTasks currentTasks = Provider.of<CurrentTasks>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        elevation: 25.0,
        title: Text(widget.title),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: FireStoreHelper.getAllRecords(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final QuerySnapshot data = snapshot.data;
                  if (data.size == 0) {
                    return Text(
                      'Create a new task.. :)',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    );
                  }
                  return NotesList(data: data, currentTasks: currentTasks);
                } else if (snapshot.hasError) {
                  return Text(
                    'ERROR...',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 50.0,
        onPressed: () {
          currentTasks.setCurrentTasks([Task('', false)]);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoScreen()),
          );
        },
        child:
            Icon(Icons.edit, size: 35.0, color: Color.fromRGBO(64, 75, 96, .9)),
      ),
    );
  }
}
