import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'calculator_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expression TEXT,
        result TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<void> saveCalculationToHistory(String expression, String result) async {
    final db = await instance.database;

    await db.insert('history', {
      'expression': expression,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<CalculationRecord>> getHistory() async {
    final db = await instance.database;
    final result = await db.query('history', orderBy: 'timestamp DESC');
    return result.map((e) => CalculationRecord.fromMap(e)).toList();
  }

  Future<void> clearHistory() async {
    final db = await instance.database;
    await db.delete('history');
  }

  Future<void> insertRecord(CalculationRecord record) async {
    final db = await instance.database;
    await db.insert('history', record.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}