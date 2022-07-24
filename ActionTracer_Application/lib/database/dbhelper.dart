import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:attempt_20/model/LogItem.dart';

class DBHelper{

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        """CREATE TABLE Employee
        (
        id INTEGER PRIMARY KEY, 
        idName TEXT, 
        time TEXT, 
        accX TEXT)"""
    );
    print("Created tables");
  }

  // Retrieving employees from Employee Tables
  Future<List<LogItem>> getEmployees() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM LogItem');
    List<LogItem> employees = new List();
    for (int i = 0; i < list.length; i++) {
      employees.add(new LogItem(list[i]["idName"], list[i]["time"], list[i]["accX"]));
    }
    print(employees.length);
    return employees;
  }

  void saveEmployee(LogItem employee) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Employee(idName, time, accX ) VALUES(' +
              '\'' +
              employee.idName +
              '\'' +
              ',' +
              '\'' +
              employee.time.toString() +
              '\'' +
              ',' +
              '\'' +
              employee.accX.toString() +
              '\'' +
              ')');
    });
  }


}

