import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list_app/Model/Model.dart';
import 'package:to_do_list_app/services/Data_Repository.dart';
import '../Color_From_Hex.dart';
import '../services/Data_Repository.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  Color deviderColor = colorFromHex('#CAC1C1');
  Color textColor = colorFromHex('#707070');
  TextEditingController contentController = TextEditingController();
  int counter = 0;
  DataRepository repository = new DataRepository();
  List<NotesModel> noteModelList = [];
  NotesModel currentNote;
  bool isNewNote = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 13, 0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      children: <Widget>[
                        Image.asset('images/light-up.png'),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            "My list ",
                            style: TextStyle(
                                fontFamily: 'Helvetica Regular',
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                 toolBar(),
                  Expanded(child: _buildBody(context))
                ],
              ),
            )),
          ],
        ),
      ),
    ));
  }

  Widget toolBar() =>Row(
    children: <Widget>[
      Expanded(flex: 4,child: Container(),),
      Expanded(flex: 3,
        child: isNewNote
            ? InkWell(
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(Icons.check),
              ),
              Text(
                "Save",
                style: TextStyle(
                    fontFamily: 'Helvetica Regular',
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          onTap: (){
            setState(() {
              isNewNote =! isNewNote;
            });
          },
        )
            : InkWell(
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(Icons.add),
              ),
              Text(
                "Add",
                style: TextStyle(
                    fontFamily: 'Helvetica Regular',
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          onTap: (){
            setState(() {
              isNewNote =! isNewNote;
              newNote();
            });
          },
        ),),
      Expanded(flex: 3,child: Container()),
    ],
  );

 void newNote(){
    NotesModel newNote = new NotesModel(note:"SS",isContinued: false,isCompleted:false );
    repository.addNote(newNote);
 }
 void deleteNote(NotesModel note)
 {
   repository.deleteNote(note);
 }
  void getNoteFromSnapshot(DocumentSnapshot snapshot) // pass the snapshot into the model
  {
    currentNote = NotesModel.fromSnapshot(snapshot) ?? Container();
    if(currentNote.note!="") {
      noteModelList.add(currentNote);
    }
    else{
      print("empty note");
      deleteNote(currentNote);
    }
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: repository.getStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        else {
          return _buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  void isCompletedPressed() {
    currentNote.isCompleted = !currentNote.isCompleted;
    repository.updateNote(currentNote);
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> noteList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: noteList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          getNoteFromSnapshot(noteList[index]);
          return Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: noteModelList[index].isCompleted
                          ? Icon(Icons.radio_button_checked)
                          : Icon(Icons.radio_button_unchecked),
                      onPressed: () {
                        setState(() {
                          noteModelList[index].isCompleted =
                              !noteModelList[index].isCompleted;
                          repository.updateNote(noteModelList[index]);
                        });
                      })),
              Expanded(
                  flex: 8,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    initialValue: noteModelList[index].note,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                    onChanged: (text){
                      noteModelList[index].note = text;
                      repository.updateNote(noteModelList[index]);
                    },
                  )),
              Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: noteModelList[index].isContinued
                          ? Icon(Icons.star)
                          : Icon(Icons.star_border),
                      onPressed: () {
                        setState(() {
                          noteModelList[index].isContinued =
                          !noteModelList[index].isContinued;
                          repository.updateNote(noteModelList[index]);
                        });
                      })),
            ],
          );
        });
  }
}
