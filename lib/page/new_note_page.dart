import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/Model/Model.dart';
import 'home_page.dart';

class NewNotePage extends StatefulWidget {
  NotesModel passNote;

  NewNotePage({Key key,this.passNote});
  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  DateTime currentTime ;
  Timestamp currentTimeStamp ;
  NotesModel note;
  @override
  void initState() {
    note = widget.passNote;
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
                child: note.note.isEmpty?
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context, note);
                    });
                  },
                  ):
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: ()  {
                    setState(() {
                      currentTime = DateTime.now();
                      currentTimeStamp = Timestamp.fromDate(currentTime);
                      note.time = currentTimeStamp;
                      Navigator.pop(context, note);
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
                    initialValue: note.note,
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
                          note.note = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        note.isImportant?Icon(Icons.star):Icon(Icons.star_border),
                        Padding(
                          padding: const EdgeInsets.only(left:12),
                          child: Text("It is very important !!!"),
                        )
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        note.isImportant =!note.isImportant;
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



