import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../entities/news.dart';
import '../repositories/news_repository.dart';
import '../../core/error/failures.dart';

class GetNewsList {
  final NewsRepository repository;
  final Map<String, int> _categoryCache = {};

  GetNewsList(this.repository);

  Future<int?> _getCategoryIdByName(String categoryName) async {
    if (_categoryCache.containsKey(categoryName)) {
      return _categoryCache[categoryName];
    }
    print(
      'Debug: Iniciando _getCategoryIdByName para categoria: $categoryName',
    );
    final response = await http.get(
      Uri.parse('https://cinformonline.com.br/wp-json/wp/v2/categories'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = json.decode(response.body);
      for (var category in categoriesJson) {
        if (category['name'] == categoryName) {
          print(
            'Debug: Categoria encontrada: ${category['name']}, ID: ${category['id']}',
          );
          _categoryCache[categoryName] = category['id'];
          return category['id'];
        }
      }
      print(
        'Debug: Categoria "$categoryName" NÃO ENCONTRADA na API de categorias.',
      );
      return null; // Categoria não encontrada
    } else {
      print(
        'Debug: ERRO ao buscar categorias para encontrar ID de "$categoryName". Status code: ${response.statusCode}',
      );
      throw Exception(
        'Failed to load categories: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Future<Either<Failure, List<News>>> execute({
    int page = 1,
    String? categoryName,
  }) async {
    try {
      int? categoryId;
      if (categoryName != null) {
        categoryId = await _getCategoryIdByName(categoryName);
        if (categoryId == null) {
          return Left(ServerFailure());
        }
      }
      final categoryFilter =
          categoryId != null ? '&categories=$categoryId' : '';
      final url =
          'https://cinformonline.com.br/wp-json/wp/v2/posts?_embed&orderby=date&order=desc&page=$page$categoryFilter';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> newsJson = json.decode(response.body);
        final newsList = newsJson.map((json) => News.fromJson(json)).toList();
        return Right(newsList);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
