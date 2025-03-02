import '../repositories/news_repository.dart';

class GetCategories {
  final NewsRepository repository;

  GetCategories(this.repository);

  Future<List<String>> execute() async {
    return await repository.getCategories();
  }
}
