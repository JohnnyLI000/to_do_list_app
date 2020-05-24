import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:to_do_list_app/Model/Model.dart';
import 'package:to_do_list_app/page/new_note_page.dart';
import 'package:to_do_list_app/services/Data_Repository.dart';
import '../Color_From_Hex.dart';
import '../services/Data_Repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color deviderColor = colorFromHex('#CAC1C1');
  Color textColor = colorFromHex('#707070');
  Color mainOrange = colorFromHex("#EF8863");
  static DataRepository repository = new DataRepository();
  List<NotesModel> noteModelList = [];
  NotesModel currentNote;
  TextEditingController textController;

  int completed = 0;
  @override
  void initState() {
    textController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textController.dispose();
    super.dispose();
  }

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
                                Container(
                                  child:Row(
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
                                Padding(
                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/1.78),
                                  child: Container(
                                    child: RichText(
                                        text: TextSpan(text: completed.toString(),
                                              style: TextStyle(
                                              color: mainOrange, fontSize: 18),
                                          children: <TextSpan>[
                                          TextSpan(text: '/'+noteModelList.length.toString(),style: TextStyle(
                                              color: Colors.black, fontSize: 22
                                          ))]
                                     ),),
                                  ),
                                )
  
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
        child:InkWell(
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
          onTap: () async{
            NotesModel newNote = new NotesModel(note: "",isContinued: false,isCompleted: false);
            NotesModel addNewNoteResult = await
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewNotePage(passNote: newNote,)));
              if(addNewNoteResult.note!=""){
                setState(() {
                  repository.addNote(addNewNoteResult);
                });
              }
          },
        )),
      Expanded(flex: 3,child: Container()),
    ],
  );


  void getNoteFromDocuments( List<DocumentSnapshot> noteList)
  {
    noteModelList.clear();
    completed=0;
    for(int i = 0;i<noteList.length;i++)
      {
        currentNote = NotesModel.fromSnapshot(noteList[i]) ?? Container();
        if(currentNote.note!="") {
          noteModelList.add(currentNote);
          if(currentNote.isCompleted)
            {
              print(completed.toString());
              completed+=1;
            }
        }
        else{
          print("empty note");
          repository.deleteNote(currentNote);
        }
      }
    print("length :" + noteModelList.length.toString());
  }
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: repository.getStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        else {
            getNoteFromDocuments(snapshot.data.documents);
          return _buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  

  Widget _buildList(BuildContext context, List<DocumentSnapshot> noteList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: noteModelList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: noteModelList[index].isCompleted
                          ? Icon(Icons.radio_button_checked)
                          : Icon(Icons.radio_button_unchecked),
                      onPressed: (){
                        setState(() {
                          noteModelList[index].isCompleted =
                          !noteModelList[index].isCompleted;
                          repository.updateNote(noteModelList[index]);

                          if(noteModelList[index].isCompleted){
                            completed++;
                          }
                          else
                            {
                              completed--;
                            }
                        });
                      }
                      )),
              Expanded(
                flex: 8,
                child: InkWell(
                  onTap: ()async{
                    NotesModel editNoteResult = await
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewNotePage(passNote: noteModelList[index],)));
                    if(editNoteResult.note!=""){
                      setState(() {
                        repository.updateNote(editNoteResult);
                      });
                    }
                  },
                  child: Container(
                    child: Text(noteModelList[index].note,
                      style:TextStyle(fontSize: 18, fontWeight: FontWeight.w500,decoration: noteModelList[index].isCompleted?TextDecoration.lineThrough:null) ,),
                  ),
                ),
              ),
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
