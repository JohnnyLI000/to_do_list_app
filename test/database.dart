
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list_app/Model/Model.dart';

import '../lib/services/Data_Repository.dart';

class DatabaseService {


  // collection reference
  final CollectionReference noteCollection = Firestore.instance.collection('to_do_list');

  // get notes stream
  Stream<List<NotesModel>> get brews {
    return noteCollection.snapshots()
        .map(_noteListFromSnapshot);
  }

  List<NotesModel> _noteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return NotesModel(
          note: doc.data['note'] ?? '',
          isCompleted: doc.data['isCompleted'] ?? false,
          isContinued: doc.data['isContinued'] ?? false
      );
    }).toList();
  }


}