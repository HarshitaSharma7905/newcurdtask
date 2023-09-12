import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper
{
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;
  DBHelper._privateConstructor();
//  checking database exists or not-----
Future<Database> get database async{
  if(_database !=null){
  return _database!;
  }else{
_database= await _initDatabase();
return _database!;
  }
}
//to initialize database----
Future<Database?> _initDatabase() async{
  String path= join(await getDatabasesPath(), 'book.db');
  return await openDatabase(path,version: 1,onCreate: _onCreate);
}
//             to create database-------
Future<void> _onCreate(Database db,int version) async{
  String sql='CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT,email TEXT, city TEXT)';
  await db.execute(sql);
}
//to insert-------
Future<int> insertData(Map<String,dynamic> row) async{
  Database db= await instance.database;
  return await db.insert('users',row);
}
//to delete------
  Future<int> deleteData(int id) async {
    Database db = await instance.database;
    return await db.delete('users',where: 'id=?',whereArgs: [id]);
  }
  //to fetch-
  Future<List<Map<String,dynamic>>> fetchData() async {
    Database db = await instance.database;
    return await db.query('users');
  }
  //to update----
  Future<int> updateData(Map<String,dynamic> row) async {
    Database db = await instance.database;
    int id=row['id'];
    return await db.update('users',row,where: 'id=?',whereArgs: [id]);
  }
}