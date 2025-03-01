import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetNewsList {
  final NewsRepository repository;

  GetNewsList(this.repository);

  Future<List<News>> execute() {
    return repository.getNewsList();
  }
} 