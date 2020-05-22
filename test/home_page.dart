import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../lib/Color_From_Hex.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color deviderColor = colorFromHex('#CAC1C1');
  Color textColor = colorFromHex('#707070');
  TextEditingController contentController = TextEditingController();
  List<Widget> _noteList = [];
  FocusNode noteFocusNode;
  int counter = 0;
  bool addSelected = false;
  bool onSave = false ;
  @override
  void initState() {
    super.initState();

    noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    noteFocusNode.dispose();

    super.dispose();
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_buildBody(context),
    );
  }

//  void _addNewNote() {
//    print(_noteList.length);
//    _noteList = List.from(_noteList)
//      ..insert(0,
//        _noteItem(),
//      );
//    setState(() {
//      counter++;
//      onSave = false;
//      addSelected = !addSelected;
//    });
//  }


  Widget _noteItemList(BuildContext context ,List<DocumentSnapshot> noteList) => ListView.builder(
    shrinkWrap: true,
    itemBuilder: (context,index){
      return Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(Icons.radio_button_unchecked),
                  onPressed:null)),
          Expanded(
              flex: 8,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: true,

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: noteList[0].data['note'],
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                ),
              )),
          Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(Icons.star_border), onPressed: null)),
        ],
      );
    }

  );

  Widget _noteListWidget() => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
              child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: _noteList,
          )),
        ),
      );

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('to_do_list').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }
  Widget _buildList(BuildContext context, List<DocumentSnapshot> noteList) {
    return SafeArea(
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
                                    color: textColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _noteItemList(context, noteList)
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

}
