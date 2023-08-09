import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'events.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Event(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        descricao TEXT
      )
    ''');
  }

  // CRUD operations

  Future<int> insertEvent(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('Event', row);
  }

  Future<List<Map<String, dynamic>>> queryAllEvents() async {
    Database db = await instance.database;
    return await db.query('Event');
  }

  Future<int> updateEvent(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('Event', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEvent(int id) async {
    Database db = await instance.database;
    return await db.delete('Event', where: 'id = ?', whereArgs: [id]);
  }
}
