import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/catch_entry.dart';

class CatchLogService {
  static final CatchLogService _instance = CatchLogService._internal();
  factory CatchLogService() => _instance;
  CatchLogService._internal();

  static Database? _database;
  static const String _tableName = 'catch_entries';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'catch_log.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        fishId TEXT NOT NULL,
        fishName TEXT NOT NULL,
        fishScientificName TEXT NOT NULL,
        catchDate TEXT NOT NULL,
        location TEXT,
        notes TEXT,
        photoPath TEXT,
        weight REAL,
        length REAL,
        weather TEXT,
        bait TEXT
      )
    ''');
  }

  Future<String> addCatchEntry(CatchEntry entry) async {
    final db = await database;
    await db.insert(_tableName, entry.toJson());
    return entry.id;
  }

  Future<List<CatchEntry>> getAllCatchEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'catchDate DESC',
    );

    return List.generate(maps.length, (i) {
      return CatchEntry.fromJson(maps[i]);
    });
  }

  Future<CatchEntry?> getCatchEntryById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CatchEntry.fromJson(maps.first);
    }
    return null;
  }

  Future<List<CatchEntry>> getCatchEntriesByFishId(String fishId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'fishId = ?',
      whereArgs: [fishId],
      orderBy: 'catchDate DESC',
    );

    return List.generate(maps.length, (i) {
      return CatchEntry.fromJson(maps[i]);
    });
  }

  Future<List<CatchEntry>> searchCatchEntries(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'fishName LIKE ? OR notes LIKE ? OR location LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'catchDate DESC',
    );

    return List.generate(maps.length, (i) {
      return CatchEntry.fromJson(maps[i]);
    });
  }

  Future<void> updateCatchEntry(CatchEntry entry) async {
    final db = await database;
    await db.update(
      _tableName,
      entry.toJson(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteCatchEntry(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllCatchEntries() async {
    final db = await database;
    await db.delete(_tableName);
  }

  // Statistics methods
  Future<int> getTotalCatchCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, int>> getCatchCountBySpecies() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT fishName, COUNT(*) as count 
      FROM $_tableName 
      GROUP BY fishName 
      ORDER BY count DESC
    ''');

    Map<String, int> speciesCount = {};
    for (var row in result) {
      speciesCount[row['fishName']] = row['count'];
    }
    return speciesCount;
  }

  Future<List<CatchEntry>> getRecentCatches({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'catchDate DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return CatchEntry.fromJson(maps[i]);
    });
  }

  Future<List<CatchEntry>> getCatchesByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'catchDate BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'catchDate DESC',
    );

    return List.generate(maps.length, (i) {
      return CatchEntry.fromJson(maps[i]);
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

