import '../entities/news.dart';

abstract class NewsRepository {
  Future<List<News>> getNewsList();
  Future<News> getNewsDetail(int id);
} 