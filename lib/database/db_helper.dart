import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper dbHero = DBHelper._secretDBConstructor();
  static Database? _database;

  DBHelper._secretDBConstructor();

  Future<Database> get dataBase async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Starts database.
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // Create the table on SQLite.
  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE time (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time TEXT,
        description TEXT
      )
    ''');
  }

  // Insert data on SQLite.
  Future<int> insertTime(Map<String, dynamic> row) async {
    Database db = await dbHero.dataBase;
    return await db.insert('time', row);
  }

  // Get data on SQLite.
  Future<List<Map<String, dynamic>>> getAllTimes() async {
    Database db = await dbHero.dataBase;
    return await db.query('time');
  }

  // Update data on table.
  Future<int> updateTime(Map<String, dynamic> row) async {
    Database db = await dbHero.dataBase;
    int id = row['id'];
    return await db.update('time', row, where: 'id = ?', whereArgs: [id]);
  }

  // Delete data on table.
  Future<int> deleteTime(int id) async {
    Database db = await dbHero.dataBase;
    return await db.delete('time', where: 'id = ?', whereArgs: [id]);
  }
}