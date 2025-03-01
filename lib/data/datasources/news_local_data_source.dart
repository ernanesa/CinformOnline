import 'package:hive/hive.dart';
import '../models/news_model.dart';

class NewsLocalDataSource {
  final String boxName = 'newsBox';

  Future<List<NewsModel>> getCachedNews() async {
    final box = Hive.box<NewsModel>(boxName);
    return box.values.toList();
  }

  Future<void> cacheNews(List<NewsModel> newsList) async {
    final box = Hive.box<NewsModel>(boxName);
    await box.clear(); // Limpa o cache antigo
    await box.addAll(newsList); // Adiciona as novas notícias
  }
} 