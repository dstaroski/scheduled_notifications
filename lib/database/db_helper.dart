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
      CREATE TABLE my_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time TEXT
      )
    ''');
  }

  // Insert data on SQLite.
  Future<int> insertDb(Map<String, dynamic> row) async {
    Database db = await dbHero.dataBase;
    return await db.insert('my_table', row);
  }

  // Get data on SQLite.
  Future<List<Map<String, dynamic>>> readDb() async {
    Database db = await dbHero.dataBase;
    return await db.query('my_table');
  }

  // Update data on table.
  Future<int> updateDb(Map<String, dynamic> row) async {
    Database db = await dbHero.dataBase;
    int id = row['id'];
    return await db.update('my_table', row, where: 'id = ?', whereArgs: [id]);
  }

  // Delete data on table.
  Future<int> deleteDb(int id) async {
    Database db = await dbHero.dataBase;
    return await db.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }
}