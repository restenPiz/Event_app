import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/event.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'event.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertEvent(Event event) async {
    final Database db = await instance.database;
    return await db.insert('event', event.toMap());
  }

  Future<List<Event>> fetchEvent() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('Event');

    return List.generate(maps.length, (index) {
      return Event.fromMap(maps[index]);
    });
  }

  Future<int> updateEvent(Event event) async {
    final Database db = await instance.database;
    return await db.update('event', event.toMap(),
        where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> deleteEvent(int id) async {
    final Database db = await instance.database;
    return await db.delete('event', where: 'id = ?', whereArgs: [id]);
  }
}
