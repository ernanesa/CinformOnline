import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/news_model.dart';

class NewsLocalDataSource {
  final Box<NewsModel> newsBox = Hive.box<NewsModel>('newsBox');
  final Dio dio = Dio();

  Future<void> saveNews(List<NewsModel> newsList) async {
    await newsBox.clear();
    for (var news in newsList) {
      final imagePath = await _downloadImage(news.imageUrl);
      final updatedNews = news.copyWith(imagePath: imagePath);
      await newsBox.add(updatedNews);
    }
  }

  List<NewsModel> getNews() {
    return newsBox.values.toList();
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
