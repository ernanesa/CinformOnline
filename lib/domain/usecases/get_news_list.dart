import 'package:http/http.dart' as http;
import 'dart:convert';
import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetNewsList {
  final NewsRepository repository;

  GetNewsList(this.repository);

  Future<List<News>> execute() async {
    final response = await http.get(
      Uri.parse(
        'https://cinformonline.com.br/wp-json/wp/v2/posts?_embed&orderby=date&order=desc',
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> newsJson = json.decode(response.body);
      return newsJson.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
