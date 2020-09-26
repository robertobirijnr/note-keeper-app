import 'package:flutter/material.dart';
import 'AddorEdit.dart';

class NoteList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
    throw UnimplementedError();
  }

}

class NoteListState extends State<NoteList>{
  var count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint("FAB clicked");
          navigatonextPage("Add Note");
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
              backgroundColor: Colors.yellowAccent,
              child: Icon(Icons.keyboard_arrow_right),
            ) ,
            title: Text("Dummy Tite",style: titleStyle),
            subtitle: Text("Dummy Date"),

            trailing: Icon(Icons.delete, color:Colors.grey),

            onTap: (){
              debugPrint("Hey You tap me");
              navigatonextPage("Edit Note");
            },
          )
        );
    }
  );
  }
  void navigatonextPage(String title){
    Navigator.push(context,MaterialPageRoute(builder:(contex){
      return Add(title);
    }));
  }
}