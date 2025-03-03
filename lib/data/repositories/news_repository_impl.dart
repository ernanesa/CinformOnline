import 'package:cinform_online/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/news_model.dart';
import 'package:cinform_online/core/network/network_info.dart';

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
  Future<Either<Failure, List<News>>> getNewsList({
    int page = 1,
    String? categoryName,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await remoteDataSource.getNewsList();
        await localDataSource.saveNews(remoteNews);
        return Right(remoteNews.map((news) => news.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localNews = localDataSource.getNews();
        return Right(localNews.map((news) => news.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<News> getNewsDetail(int id) async {
    final NewsModel newsModel = await remoteDataSource.getNewsDetail(id);
    return newsModel.toEntity();
  }

  @override
  Future<List<String>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories = await remoteDataSource.getCategories();
        return remoteCategories;
      } on Exception {
        throw ServerFailure();
      }
    } else {
      throw CacheFailure();
    }
  }
}
