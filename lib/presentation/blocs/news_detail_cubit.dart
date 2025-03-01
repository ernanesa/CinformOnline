import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/news.dart';

class NewsDetailCubit extends Cubit<News> {
  NewsDetailCubit(News initialState) : super(initialState);

  void setNews(News news) {
    emit(news);
  }
} 