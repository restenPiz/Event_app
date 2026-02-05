import 'dart:async';
import 'package:event_app/models/Truck.dart';
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
      join(dbPath, 'trucks.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Truck(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        matricula TEXT NOT NULL,
        marca TEXT NOT NULL,
        modelo TEXT NOT NULL,
        ano INTEGER NOT NULL,
        motorista TEXT NOT NULL,
        status TEXT NOT NULL,
        quilometragem REAL NOT NULL,
        observacoes TEXT
      )
    ''');
  }

  // CRUD Operations

  Future<int> insertTruck(Truck truck) async {
    Database db = await instance.database;
    return await db.insert('Truck', truck.toMap());
  }

  Future<List<Truck>> queryAllTrucks() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps =
        await db.query('Truck', orderBy: 'id DESC');
    return List.generate(maps.length, (index) {
      return Truck.fromMap(maps[index]);
    });
  }

  Future<Truck?> queryTruckById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'Truck',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Truck.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTruck(Truck truck) async {
    Database db = await instance.database;
    return await db.update(
      'Truck',
      truck.toMap(),
      where: 'id = ?',
      whereArgs: [truck.id],
    );
  }

  Future<int> deleteTruck(int id) async {
    Database db = await instance.database;
    return await db.delete('Truck', where: 'id = ?', whereArgs: [id]);
  }

  // Estatísticas
  Future<Map<String, int>> getStatusCount() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT status, COUNT(*) as count 
      FROM Truck 
      GROUP BY status
    ''');

    Map<String, int> statusCount = {};
    for (var row in result) {
      statusCount[row['status']] = row['count'];
    }
    return statusCount;
  }
}
