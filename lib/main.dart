import 'package:flutter/material.dart';
import './Screens/NoteList.dart';

void main(){
  runApp(NoteKeeper());
}

class NoteKeeper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"NoteKeeper",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: NoteList(),
    );
    throw UnimplementedError();
  }

}