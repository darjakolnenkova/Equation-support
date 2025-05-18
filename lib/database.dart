import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'calculator_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();  // создание единственного экземпляра класса

  static Database? _database;  // приватная переменная — тут будет храниться сама база

  DatabaseHelper._init();  // приватный конструктор — используется только внутри класса

  Future<Database> get database async {  // получение БД (или создание)
    if (_database != null) return _database!;

    _database = await _initDB('history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {    // инициализация базы
    final dbPath = await getDatabasesPath(); // путь к папке с базами
    final path = join(dbPath, filePath);     // полный путь к файлу базы

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {   // создание таблицы истории
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expression TEXT,
        result TEXT,
        timestamp TEXT
      )
    ''');
  }

  // сохранение вычисления: (выражение+результат+время)
  Future<void> saveCalculationToHistory(String expression, String result) async {
    final db = await instance.database;

    await db.insert('history', {
      'expression': expression,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // получение всех записей из истории:
  // загрузка всех строк из таблицы history, превращение их в объекты CalculationRecord:
  Future<List<CalculationRecord>> getHistory() async {
    final db = await instance.database;
    final result = await db.query('history', orderBy: 'timestamp DESC');
    return result.map((e) => CalculationRecord.fromMap(e)).toList();
  }

  Future<void> clearHistory() async { // очистить историю
    final db = await instance.database;
    await db.delete('history');
  }

  Future<void> insertRecord(CalculationRecord record) async {  // вставить готовый объект записи (например, с конвертацией)
    final db = await instance.database;
    await db.insert('history', record.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
