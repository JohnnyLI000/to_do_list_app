import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list_app/Model/Model.dart';

class DataRepository {
  // 1
  final CollectionReference collection = Firestore.instance.collection('to_do_list');
  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addNote(NotesModel note) {
    print("Added");
    return collection.add(note.toJson());
  }
  deleteNote(NotesModel note) {
    Firestore.instance.runTransaction((transaction) async {
      print("deleted");
      transaction.delete(note.reference);
    });
  }
  // 4
  updateNote(NotesModel note) async {
    await collection.document(note.reference.documentID).updateData(note.toJson());
    print('success update');
  }
}