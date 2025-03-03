import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'news_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE news (id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, imageUrl TEXT, imagePath TEXT, category TEXT)',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getNews() async {
    final db = await database;
    return await db.query('news');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
