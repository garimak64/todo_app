import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/screen/second_screen.dart';
import 'package:todoapp/state/current_tasks.dart';

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
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
        home: MyHomePage(
          title: 'TO-DO',
        ),
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
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(widget.title),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: db.collection('notes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final QuerySnapshot data = snapshot.data;
                  if (data.size == 0) {
                    return Text(
                      'Add your first task...',
                      style: GoogleFonts.mcLaren(
                        textStyle:
                            TextStyle(color:
                                Colors.white,
                            //Color(0xFF61656A),
                               fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        final String title = data.docs[index].data()['title'];
                        final detail = data.docs[index].data()['tasks'][0];
                        return Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: makeListTile(
                                  data, index, currentTasks, title, detail)),
                        );

                        // return getInkWell(data, index, title, currentTasks);
                      });
                } else {
                  return CircularProgressIndicator();
                }
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          currentTasks.setCurrentTasks([Task('', false)]);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.edit,
        color: Color.fromRGBO(58, 66, 86, 1.0),
        size: 30,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _readData() async {
    DocumentSnapshot snapshot = await db.collection('notes').doc(id).get();
    print(snapshot.data()['title']);
  }

  InkWell getInkWell(data, index, title, currentTasks) {
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
                builder: (context) => SecondRoute(
                      title: title,
                      documentID: data.docs[index].id,
                    )),
          );
        },
        child: Container(
            child: Text(
          title,
          style: TextStyle(fontSize: 20.0),
        )));
  }

  ListTile makeListTile(data, index, currentTasks, title, detail) => ListTile(
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
                builder: (context) => SecondRoute(
                      title: title,
                      documentID: data.docs[index].id,
                    )),
          );
        },
      );
}
