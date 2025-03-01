import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/news.dart';
import '../../domain/usecases/get_news_list.dart';

// Events
abstract class NewsListEvent {}

class LoadNewsList extends NewsListEvent {}

// States
abstract class NewsListState {
  final List<News> newsList;

  NewsListState({required this.newsList});
}

class NewsListInitial extends NewsListState {
  NewsListInitial() : super(newsList: []);
}

class NewsListLoading extends NewsListState {
  NewsListLoading() : super(newsList: []);
}

class NewsListLoaded extends NewsListState {
  NewsListLoaded({required List<News> newsList}) : super(newsList: newsList);
}

class NewsListError extends NewsListState {
  final String message;

  NewsListError({required this.message}) : super(newsList: []);
}

// Bloc
class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final GetNewsList getNewsList;

  NewsListBloc(this.getNewsList) : super(NewsListInitial()) {
    on<LoadNewsList>((event, emit) async {
      emit(NewsListLoading());
      try {
        final List<News> newsList = await getNewsList.execute();
        emit(NewsListLoaded(newsList: newsList));
      } catch (e) {
        emit(NewsListError(message: e.toString()));
      }
    });
  }
} 