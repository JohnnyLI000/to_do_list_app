import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String note;
  bool isContinued;
  bool isCompleted;
  Timestamp time;
  NotesModel({this.note, this.isContinued,this.isCompleted,this.time});

  DocumentReference reference;

  factory NotesModel.fromSnapshot(DocumentSnapshot snapshot) {
    NotesModel newNotes = NotesModel.fromJson(snapshot.data);
    newNotes.reference = snapshot.reference;
    return newNotes;

  }
  factory NotesModel.fromJson(Map<String, dynamic> json) => _notesFromJson(json); //this one is problem in the sample code
  //factory NotesModel.fromJson(Map<String, dynamic> json) => _notesFromJson(json);

  Map<String, dynamic> toJson() => _notesToJson(this);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'note': this.note,
      'isContinued': this.isContinued == true ? 1 : 0,
      'isCompleted': this.isCompleted== true ? 1 : 0,
      'time': this.time
    };
  }

  static NotesModel _notesFromJson (Map<String, dynamic> json) => NotesModel(
        note: json['note'] as String,
        isContinued: json['isContinued'] as bool,
       isCompleted: json['isCompleted'] as bool,
      time: json['time'] as Timestamp
  );

  Map<String, dynamic> _notesToJson(NotesModel note) => <String, dynamic> {
    'note': note.note,
    'isCompleted': note.isCompleted,
    'isContinued': note.isContinued,
    'time':note.time,
  };
}
