import 'package:cinform_online/core/network/network_info.dart';
import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../datasources/news_local_data_source.dart';
import '../models/news_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.networkInfo,
  );

  @override
  Future<List<News>> getNewsList() async {
    if (await networkInfo.isConnected) {
      try {
        final List<NewsModel> newsModels = await remoteDataSource.getNewsList();
        localDataSource.cacheNews(newsModels); // Cache as notícias
        return newsModels.map((model) => model.toEntity()).toList();
      } catch (e) {
        throw e;
      }
    } else {
      // Se não houver conexão, busca do cache
      final List<NewsModel> cachedNews = await localDataSource.getCachedNews();
      if (cachedNews.isNotEmpty) {
        return cachedNews.map((model) => model.toEntity()).toList();
      } else {
        throw Exception('No internet connection and no cached data');
      }
    }
  }

  @override
  Future<News> getNewsDetail(int id) async {
    // Implemente a lógica de cache para detalhes da notícia, se necessário
    final NewsModel newsModel = await remoteDataSource.getNewsDetail(id);
    return newsModel.toEntity();
  }
}
