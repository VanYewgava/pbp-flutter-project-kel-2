import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pbp_project_flutter_speedrun/models/task_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String taskTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';
  String colStatus = 'status';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/tasks.db';

    var tasksDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return tasksDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $taskTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT,
        $colDescription TEXT,
        $colPriority TEXT,
        $colDate TEXT,
        $colStatus INTEGER
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await database;
    var result = await db.query(taskTable, orderBy: '$colId DESC');
    return result;
  }

  Future<int> insertTask(Task task) async {
    Database db = await database;
    var result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    var db = await database;
    var result = await db.update(
      taskTable,
      task.toMap(),
      where: '$colId = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  Future<int> deleteTask(int id) async {
    var db = await database;
    int result = await db.delete(
      taskTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int?> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x = await db.rawQuery(
      'SELECT COUNT (*) from $taskTable',
    );
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    var taskMapList = await getTaskMapList();
    return taskMapList.map((taskMap) => Task.fromMap(taskMap)).toList();

    // var taskMapList = await getTaskMapList();
    // int count = taskMapList.length;

    // List<Task> taskList = [];
    // for (int i = 0; i < count; i++) {
    //   taskList.add(Task.fromMap(taskMapList[i]));
    // }

    // return taskList;
  }

  Future<int> deleteAllTasks() async {
    var db = await database;
    int result = await db.delete(taskTable); 
    return result;
  }
}

