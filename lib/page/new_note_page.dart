import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/Model/Model.dart';
import 'home_page.dart';

class NewNotePage extends StatefulWidget {
  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  NotesModel newNote;
  DateTime currentTime ;
  Timestamp currentTimeStamp ;

  @override
  void initState() {
    newNote = new NotesModel(note: "",isContinued: false,isCompleted: false);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: <Widget>[
                Container(
                child: newNote.note.isEmpty?
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context, newNote);
                    });
                  },
                  ):
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: ()  {
                    setState(() {
                      currentTime = DateTime.now();
                      currentTimeStamp = Timestamp.fromDate(currentTime);
                      newNote.time = currentTimeStamp;
                      Navigator.pop(context, newNote);
                  });
                  },
                ),
                ),
                Container(
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: "I want to ",
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
                      setState(() {
                          newNote.note = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        newNote.isContinued?Icon(Icons.radio_button_checked):Icon(Icons.radio_button_unchecked),
                        Text("Do it everyday")
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        newNote.isContinued =!newNote.isContinued;
                      });
                    },
                  ),
                )
              ]),
            ),
          )),
    );
  }

  void _popNavigationWithResult(BuildContext context,dynamic result) {
    Navigator.pop(context,result);
  }
}



