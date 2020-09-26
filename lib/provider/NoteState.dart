import 'package:flutter/material.dart';
import 'package:todoapp/model/note.dart';

class NoteState extends ChangeNotifier{

  List<Note> _notes = new List();

  List<Note> get notes => _notes;

  setNotes(Note value) {
    _notes.add(value);
    notifyListeners();
  }


}