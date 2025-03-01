import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/news.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<News>>> getNewsList();
  Future<News> getNewsDetail(int id);
}
