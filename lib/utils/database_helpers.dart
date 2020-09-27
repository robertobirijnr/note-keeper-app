import "package:sqflite/sqflite.dart";
import "dart:async";
import "dart:io";
import "package:path_provider/path_provider.dart";
import "package:note_keeper/models/Notes.dart";

class DatabaseHelper {
  //singleton DatabaseHelper
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  //Named constructor to create instance of Database helper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      //This is executed only once, singleton object
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for both android and IOS to store database;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    //Open/create the database at a given path
    var noteDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return noteDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable'
        '($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, '
        '$colDate TEXT');
  }
  //Performing SQL CRUD

  //Fetch Operation :Get all note objects from database
Future<List<Map<String, dynamic>>>getNoteMapList() async{
   Database db = await this.database;
   var result = await db.query(noteTable, orderBy:'$colPriority ASC');
   return result;
}

//Insert Operation: nsert a Note object to database
Future<int>InsertNote(Note note) async{
   Database db = await this.database;
   var result = await db.insert(noteTable, note.toMap());
   return result;
}

//Update Operation: Update a Noted Object and save it to database
Future<int>UpdateNote(Note note) async{
   Database db = await this.database;
   var result = await db.update(noteTable, note.toMap(), where:'$colId = ?', whereArgs: [note.id]);
   return result;
}

//Delete Operation: Delete a note object from dabase
Future<int>DeleteNote(int id)async{
   var db = await this.database;
   int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
   return result;
}

//Get number of Note objects in database
Future<int>getCount()async{
   var db = await this.database;
   List<Map<String, dynamic>> x = await db.rawQuery("SELETE COUNT (*) from $noteTable");
   int result = Sqflite.firstIntValue(x);
   return result;
}
Future<List<Note>>getNoteList() async{
   var noteMapList = await getNoteMapList();
   int count = noteMapList.length;

   List<Note>noteList = List<Note>();
   for(int i =0 ; i< count; i++){
     noteList.add(Note.fromMapObject(noteMapList[i]));
   }
   return noteList;
}
}
