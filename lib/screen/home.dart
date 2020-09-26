import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note.dart';
import 'package:todoapp/provider/NoteState.dart';
import 'package:todoapp/screen/todo_editor.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    NoteState notestate = Provider.of<NoteState>(context);
    List litems = notestate.notes;
    bool emptynotes = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      Center(
        child:  ListView.builder(
          itemCount: litems.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Padding(
                padding: const EdgeInsets.only(left:18.0, top: 10,bottom: 15),
                child: GestureDetector(
                  onTap: (){print("tap");} ,
                  child: Text(litems[index].title,
                  style: TextStyle(
                    fontSize: 23,
                  ),),
                ),
              );

            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoEditor()),
          );
        },
        tooltip: 'Add todo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget _buildBlankView() => SliverFillRemaining(
    hasScrollBody: false,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Expanded(flex: 1, child: SizedBox()),
        ImageIcon(
          //Icons.edit,
          //AppIcons.thumbtack,
          AssetImage("assets/images/thumbtack.png"),
          size: 40,
          color:
          Colors.teal[300],
          //kAccentColorLight.shade300,
        ),
        Expanded(
          flex: 2,
          child: Text('Add your first task',
            style: TextStyle(
              color:
              // Colors.white,
              Color(0xFF61656A),
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );


}


