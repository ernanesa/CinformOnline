import 'package:cinform_online_news/core/network/api_client.dart';
import 'package:cinform_online_news/data/models/news_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsRemoteDataSource {
  final ApiClient apiClient;

  NewsRemoteDataSource({required this.apiClient});

  Future<List<NewsModel>> getNewsList() async {
    final response =
        await apiClient.get(
              '/wp-json/wp/v2/posts?_embed&orderby=date&order=desc',
            )
            as http.Response;
    if (response.statusCode == 200) {
      final List<dynamic> newsJson = json.decode(response.body);
      return newsJson.map((json) => NewsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<NewsModel> getNewsDetail(int id) async {
    final response =
        await apiClient.get('/wp-json/wp/v2/posts/$id?_embed') as http.Response;
    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news detail');
    }
  }

  Future<List<String>> getCategories() async {
    final response =
        await apiClient.get('/wp-json/wp/v2/categories') as http.Response;
    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = json.decode(response.body);
      return categoriesJson.map((json) => json['name'] as String).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
