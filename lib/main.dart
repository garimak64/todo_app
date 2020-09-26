import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/screen/second_screen.dart';
import 'package:todoapp/state/current_tasks.dart';
import 'package:todoapp/widget/main_screen_list.dart';

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
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Todo App'),
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
  String id;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CurrentTasks currentTasks = Provider.of<CurrentTasks>(context);
    return Scaffold(
    appBar: AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(widget.title),
    ),
    body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: db.collection('notes').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final QuerySnapshot data = snapshot.data;
                return NotesList(data: data, currentTasks: currentTasks);
              } else {
                return Text('You\'re so clean... :)');
              }
            })),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        currentTasks.setCurrentTasks([Task('', false)]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondRoute()),
        );
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    ), // This trailing comma makes auto-formatting nicer for build methods.
      );
  }

  void _readData() async {
    DocumentSnapshot snapshot = await db.collection('notes').doc(id).get();
    print(snapshot.data()['title']);
  }



}
