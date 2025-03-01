import 'package:cinform_online/core/network/api_client.dart';
import '../models/news_model.dart';
import 'package:dio/dio.dart';

class NewsRemoteDataSource {
  final ApiClient apiClient;

  NewsRemoteDataSource({required this.apiClient});

  Future<List<NewsModel>> getNewsList() async {
    try {
      final response = await apiClient.get('/posts?_embed');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load news list',
        );
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw e;
    } catch (e) {
      print('Unexpected error: $e');
      throw e;
    }
  }

  Future<NewsModel> getNewsDetail(int id) async {
    try {
      final response = await apiClient.get('/posts/$id?_embed');
      if (response.statusCode == 200) {
        return NewsModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load news detail',
        );
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      throw e;
    } catch (e) {
      print('Unexpected error: $e');
      throw e;
    }
  }
}
