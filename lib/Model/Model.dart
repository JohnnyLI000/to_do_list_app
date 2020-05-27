import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String note;
  bool isImportant;
  bool isCompleted;
  Timestamp time;
  NotesModel({this.note, this.isImportant,this.isCompleted,this.time});

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
      'isImportant': this.isImportant == true ? 1 : 0,
      'isCompleted': this.isCompleted== true ? 1 : 0,
      'time': this.time
    };
  }

  static NotesModel _notesFromJson (Map<String, dynamic> json) => NotesModel(
        note: json['note'] as String,
        isImportant: json['isImportant'] as bool,
       isCompleted: json['isCompleted'] as bool,
      time: json['time'] as Timestamp
  );

  Map<String, dynamic> _notesToJson(NotesModel note) => <String, dynamic> {
    'note': note.note,
    'isCompleted': note.isCompleted,
    'isImportant': note.isImportant,
    'time':note.time,
  };
}
