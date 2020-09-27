import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import "package:note_keeper/models/Notes.dart";
import "package:sqflite/sqflite.dart";
import "package:note_keeper/utils/database_helpers.dart";

class Add extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  Add(this.note,this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return _AddorEdit(this.note,this.appBarTitle);
    throw UnimplementedError();
  }
}

class _AddorEdit extends State<Add> {
  static var _priorites = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  Note note;
  String appBarTitle;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _AddorEdit(this.note,this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 15.0, right: 10.0,left:10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorites.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint("User selected $valueSelectedByUser");
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Something changed in Title Text Field");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("some change in the description");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "save",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              debugPrint("HSjhaskja");
                              _save();
                            },
                          ),
                        ),
                        Container(width: 5.0),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Delete",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              debugPrint("sdhjshdjsdh");
                                _delete();
                            },
                          ),
                        )
                      ],
                    ))
              ],
            )));
    throw UnimplementedError();
  }
  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value){
    switch(value){
      case "High":
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority = _priorites[0];
        break;
      case 2:
        priority = _priorites[1];
        break;

    }
    return priority;
  }

  void updateTitle(){
    note.title = titleController.text;
  }
  void updateDescription(){
    note.description = descriptionController.text;
  }

  void _save() async{
    moveToLastScreen();

    int result;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    if(note.id != null){
      result = await helper.UpdateNote(note);
    }else{
      result = await helper.InsertNote(note);
    }
    if(result != 0){
      _showAlertDialog("Status","Note Saved Successfully");
    }else{
      _showAlertDialog("Status","Problem Saving Note");
    }
  }

  void _delete() async{

    moveToLastScreen();

    if(note.id == null){
      _showAlertDialog('status', 'No Note was deleted');
      return;
    }
  int result = await helper.DeleteNote(note.id);
    if(result !=0){
      _showAlertDialog('status', 'Note Deleted Successfully');
    }else{
      _showAlertDialog('status', 'Error Occured while Deleting Note');
    }

  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title:Text(title),
      content:Text(message),
    );
    showDialog(
      context: context,
      builder: (_) =>alertDialog
    );
  }
}
