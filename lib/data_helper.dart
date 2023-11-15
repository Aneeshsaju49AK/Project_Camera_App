import 'package:camera_app/imageModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseVersion = 1;

  static const table = 'students';

  static const columnId = '_id';
  static const columnImage = 'image';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'image.db',
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table ($columnId INTEGER PRIMARY KEY, $columnImage TEXT NOT NULL)');
  }

  Future<int> addImage(Images image) async {
    final db = await database;
    return await db.insert(
      table,
      {
        columnImage: image.imagePath,
      },
    );
  }

  Future<List<Images>> getImages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(
      maps.length,
      (index) => Images(
        id: maps[index][columnId],
        imagePath: maps[index][columnImage],
      ),
    );
  }

  Future<int> deleteImage(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
