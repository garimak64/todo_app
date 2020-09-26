
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/note.dart';
import 'package:todoapp/provider/NoteState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoEditor extends StatefulWidget {


  @override
  _TodoEditorState createState() => _TodoEditorState();

}

class _TodoEditorState extends State<TodoEditor> {

  List<String> listItems = [];
  List<bool> listCheck = [];

  final TextEditingController titleCtrl = new TextEditingController();
  final TextEditingController detailCtrl = new TextEditingController();

  final databaseReference = FirebaseFirestore.instance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NoteState notestate = Provider.of<NoteState>(context);

    return WillPopScope(
      onWillPop: () => _onPop(notestate),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Write TO-DO",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        body: _buildNoteDetail(),


      ),
    );
  }

  Widget _buildNoteDetail() =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:12.0,top: 10),
            child: TextField(
              controller: titleCtrl,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                counter: const SizedBox(),
              ),
              maxLines: null,
              maxLength: 1024,
              textCapitalization: TextCapitalization.sentences,
            //  readOnly: !_note.state.canEdit,
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left:12.0),
            child: TextField(
              controller: detailCtrl,
              style: TextStyle(
                fontSize: 18,
              ),
              decoration: const InputDecoration.collapsed(hintText: 'Note'),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,

             // readOnly: !_note.state.canEdit,
            ),
          ),

        ],
      );


  Future<bool> _onPop(NoteState notestate) {

   notestate.setNotes( Note(titleCtrl.text, detailCtrl.text));
   createRecord();
    return Future.value(true);
  }

  void createRecord() async{
    await databaseReference.collection("notes")
        .add({
      'title': titleCtrl.text,
      'detail': detailCtrl.text
    });
  }

  void getData() {
    databaseReference
        .collection("notes").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) => print('${f.data()}}'));
    });
  }

  void updateData() {
    try {
      databaseReference
          .collection('notes')
          .doc('1')
          .update({
        'title': titleCtrl.text,
        'detail': detailCtrl.text});
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteData() {
    try {
      databaseReference
          .collection('notes')
          .doc('1QftUS7jtLo9mPSiGCu6')
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

}
