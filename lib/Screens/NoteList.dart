import 'package:flutter/material.dart';
import 'AddorEdit.dart';
import 'dart:async';
import "package:note_keeper/models/Notes.dart";
import "package:sqflite/sqflite.dart";
import "package:note_keeper/utils/database_helpers.dart";

class NoteList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return NoteListState();
    throw UnimplementedError();
  }

}

class NoteListState extends State<NoteList>{
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint("FAB clicked");
          navigatonextPage(Note("","",2),"Add Note");
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
    throw UnimplementedError();
  }
 ListView getNoteListView(){
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

  return ListView.builder(
      itemCount: count,
    itemBuilder: (BuildContext context, int position){
        return Card(
          color:Colors.white,
          elevation:2.0,
          child:ListTile(
            leading:CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: Icon(Icons.keyboard_arrow_right),
            ) ,
            title: Text(this.noteList[position].title, style: titleStyle,),
            subtitle: Text(this.noteList[position].date),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color:Colors.grey),
              onTap: (){
                _delete(context, noteList[position]);
              },
            ),

            onTap: (){
              debugPrint("Hey You tap me");
              navigatonextPage(this.noteList[position],"Edit Note");
            },
          )
        );
    }
  );
  }

  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async{
    int result = await databaseHelper.DeleteNote(note.id);
    if(result !=0){
      _showSnackBar(context,"Note Deleted Successfully");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context,String message){
    final snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void navigatonextPage(Note note,String title) async{
  bool result = await Navigator.push(context,MaterialPageRoute(builder:(contex){
      return Add(note,title);
    }));

  if(result == true){
    updateListView();
  }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>>noteListFutre = databaseHelper.getNoteList();
      noteListFutre.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count= noteList.length;
        });
      });
    });
  }
}

