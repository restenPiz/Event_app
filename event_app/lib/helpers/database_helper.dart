import 'dart:async';
import 'package:event_app/models/Manuntencao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/truck.dart';
import '../models/abastecimento.dart';

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
      version: 2,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de Camiões
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
        observacoes TEXT,
        fotoPath TEXT
      )
    ''');

    // Tabela de Manutenções
    await db.execute('''
      CREATE TABLE Manutencao(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        truckId INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        custo REAL NOT NULL,
        data TEXT NOT NULL,
        oficina TEXT,
        quilometragem INTEGER,
        proximaManutencao TEXT,
        FOREIGN KEY (truckId) REFERENCES Truck (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de Abastecimentos
    await db.execute('''
      CREATE TABLE Abastecimento(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        truckId INTEGER NOT NULL,
        litros REAL NOT NULL,
        precoLitro REAL NOT NULL,
        custoTotal REAL NOT NULL,
        data TEXT NOT NULL,
        quilometragem INTEGER,
        posto TEXT,
        tipoCombustivel TEXT,
        FOREIGN KEY (truckId) REFERENCES Truck (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adicionar coluna fotoPath se não existir
      await db.execute('ALTER TABLE Truck ADD COLUMN fotoPath TEXT');

      // Criar tabelas que não existiam na versão 1
      await db.execute('''
      CREATE TABLE Manutencao(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        truckId INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        custo REAL NOT NULL,
        data TEXT NOT NULL,
        oficina TEXT,
        quilometragem INTEGER,
        proximaManutencao TEXT,
        FOREIGN KEY (truckId) REFERENCES Truck (id) ON DELETE CASCADE
      )
    ''');

      await db.execute('''
      CREATE TABLE Abastecimento(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        truckId INTEGER NOT NULL,
        litros REAL NOT NULL,
        precoLitro REAL NOT NULL,
        custoTotal REAL NOT NULL,
        data TEXT NOT NULL,
        quilometragem INTEGER,
        posto TEXT,
        tipoCombustivel TEXT,
        FOREIGN KEY (truckId) REFERENCES Truck (id) ON DELETE CASCADE
      )
    ''');
    }
  }

  // ==================== CRUD TRUCKS ====================

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

  Future<int> insertManutencao(Manutencao manutencao) async {
    Database db = await instance.database;
    return await db.insert('Manutencao', manutencao.toMap());
  }

  Future<List<Manutencao>> queryManutencoesByTruck(Truck truck) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'Manutencao',
      where: 'truckId = ?',
      whereArgs: [truck.id],
      orderBy: 'data DESC',
    );
    return List.generate(maps.length, (index) {
      return Manutencao.fromMap(maps[index]);
    });
  }

  Future<List<Manutencao>> queryAllManutencoes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps =
        await db.query('Manutencao', orderBy: 'data DESC');
    return List.generate(maps.length, (index) {
      return Manutencao.fromMap(maps[index]);
    });
  }

  //Doing some updates in the application

  Future<int> updateManutencao(Manutencao manutencao) async {
    Database db = await instance.database;
    return await db.update(
      'Manutencao',
      manutencao.toMap(),
      where: 'id = ?',
      whereArgs: [manutencao.id],
    );
  }

  Future<int> deleteManutencao(int id) async {
    Database db = await instance.database;
    return await db.delete('Manutencao', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertAbastecimento(Abastecimento abastecimento) async {
    Database db = await instance.database;
    return await db.insert('Abastecimento', abastecimento.toMap());
  }

  Future<List<Abastecimento>> queryAbastecimentosByTruck(Truck truck) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'Abastecimento',
      where: 'truckId = ?',
      whereArgs: [truck.id],
      orderBy: 'data DESC',
    );
    return List.generate(maps.length, (index) {
      return Abastecimento.fromMap(maps[index]);
    });
  }

  Future<List<Abastecimento>> queryAllAbastecimentos() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps =
        await db.query('Abastecimento', orderBy: 'data DESC');
    return List.generate(maps.length, (index) {
      return Abastecimento.fromMap(maps[index]);
    });
  }

  Future<int> updateAbastecimento(Abastecimento abastecimento) async {
    Database db = await instance.database;
    return await db.update(
      'Abastecimento',
      abastecimento.toMap(),
      where: 'id = ?',
      whereArgs: [abastecimento.id],
    );
  }

  Future<int> deleteAbastecimento(int id) async {
    Database db = await instance.database;
    return await db.delete('Abastecimento', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== ESTATÍSTICAS ====================

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

  Future<double> getTotalCustoManutencao() async {
    Database db = await instance.database;
    var result =
        await db.rawQuery('SELECT SUM(custo) as total FROM Manutencao');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getTotalCustoAbastecimento() async {
    Database db = await instance.database;
    var result =
        await db.rawQuery('SELECT SUM(custoTotal) as total FROM Abastecimento');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<Map<String, dynamic>> getManutencoesPorTipo() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT tipo, COUNT(*) as count, SUM(custo) as total
      FROM Manutencao 
      GROUP BY tipo
    ''');
    return {
      for (var row in result)
        row['tipo']: {'count': row['count'], 'total': row['total']}
    };
  }

  // ==================== RELATÓRIOS ====================

  Future<Map<String, dynamic>> getRelatorioCompleto() async {
    Database db = await instance.database;

    final trucks = await queryAllTrucks();
    final manutencoes = await queryAllManutencoes();
    final abastecimentos = await queryAllAbastecimentos();

    final totalTrucks = trucks.length;
    final totalManutencoes = manutencoes.length;
    final totalAbastecimentos = abastecimentos.length;

    final custoManutencao = await getTotalCustoManutencao();
    final custoAbastecimento = await getTotalCustoAbastecimento();

    return {
      'trucks': trucks,
      'manutencoes': manutencoes,
      'abastecimentos': abastecimentos,
      'totalTrucks': totalTrucks,
      'totalManutencoes': totalManutencoes,
      'totalAbastecimentos': totalAbastecimentos,
      'custoManutencao': custoManutencao,
      'custoAbastecimento': custoAbastecimento,
      'custoTotal': custoManutencao + custoAbastecimento,
    };
  }
}
