import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/news_model.dart';

class NewsLocalDataSource {
  final Dio dio = Dio();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'news_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE news(id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, imageUrl TEXT, imagePath TEXT, category TEXT)',
        );
      },
    );
  }

  Future<void> saveNews(List<NewsModel> newsList) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var news in newsList) {
        final imagePath = await _downloadImage(news.imageUrl);
        final updatedNews = news.copyWith(imagePath: imagePath);
        await txn.insert(
          'news',
          updatedNews.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<NewsModel>> getNews() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('news');
    return List.generate(maps.length, (i) {
      return NewsModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        date: DateTime.parse(maps[i]['date']),
        imageUrl: maps[i]['imageUrl'],
        imagePath: maps[i]['imagePath'],
        category: maps[i]['category'],
      );
    });
  }

  Future<String> _downloadImage(String imageUrl) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${imageUrl.split('/').last}';
      final response = await dio.download(imageUrl, filePath);
      if (response.statusCode == 200) {
        return filePath;
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }
}
