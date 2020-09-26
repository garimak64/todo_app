import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/model/task.dart';

class FireStoreHelper {
  static final _databaseReference = FirebaseFirestore.instance;
  
  static void createRecord(String title, List<Task> tasks) async{
    List<Map> steps = tasks.map((task) => task.toMap()).toList();
    await _databaseReference.collection("notes")
        .add({
      'title': title,
      'tasks': steps,
        
    });
  }

  static void updateRecord(String title, List<Task> tasks, String documentID) async {
    List<Map> steps = tasks.map((task) => task.toMap()).toList();
    await _databaseReference.collection("notes").doc(documentID).update({
      'title': title,
      'tasks': steps,
    });
  }

  static void deleteRecord(String documentID) async {
    await _databaseReference.collection("notes").doc(documentID).delete();
  }
 
}