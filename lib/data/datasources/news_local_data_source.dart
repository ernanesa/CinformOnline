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
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE news(id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, imageUrl TEXT, imagePath TEXT, category TEXT)',
        );
        await db.execute(
          'CREATE INDEX index_news_category ON news (category)',
        ); // Add index on category column
      },
    );
  }

  Future<void> saveNews(List<NewsModel> newsList) async {
    final db = await database;
    List<Future<String>> imageDownloadFutures = [];

    for (var news in newsList) {
      imageDownloadFutures.add(_downloadImage(news.imageUrl));
    }

    final List<String> imagePaths = await Future.wait(imageDownloadFutures);

    await db.transaction((txn) async {
      for (int i = 0; i < newsList.length; i++) {
        final updatedNews = newsList[i].copyWith(imagePath: imagePaths[i]);
        await txn.insert(
          'news',
          updatedNews.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<NewsModel>> getNews({String? categoryName}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (categoryName != null && categoryName.isNotEmpty) {
      maps = await db.query(
        'news',
        where: 'category = ?',
        whereArgs: [categoryName],
      );
    } else {
      maps = await db.query('news');
    }
    return List.generate(maps.length, (i) {
      return NewsModel.fromJson(maps[i]);
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
