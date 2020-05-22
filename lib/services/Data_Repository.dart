import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list_app/Model/Model.dart';

class DataRepository {
  //
  final Query collection = Firestore.instance.collection('to_do_list').orderBy('time');

  // 2
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  // 3
  Future<DocumentReference> addNote(NotesModel note) {
    print("Added");
    return collection.reference().add(note.toJson()); //reference is the way to add
  }
  deleteNote(NotesModel note) {
    Firestore.instance.runTransaction((transaction) async {
      print("deleted");
      transaction.delete(note.reference);
    });
  }
  // 4
  updateNote(NotesModel note) async {
    await collection..reference().document(note.reference.documentID).updateData(note.toJson());
    print('success update');
  }
}