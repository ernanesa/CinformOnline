import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/news.dart';
import '../../domain/usecases/get_news_list.dart';

// Events
abstract class NewsListEvent {}

class LoadNewsList extends NewsListEvent {
  final int page;
  LoadNewsList({this.page = 1});
}

class LoadMoreNews extends NewsListEvent {
  final int page;
  LoadMoreNews({this.page = 1});
}

// States
abstract class NewsListState {
  final List<News> newsList;
  final bool hasReachedMax;

  NewsListState({required this.newsList, this.hasReachedMax = false});
}

class NewsListInitial extends NewsListState {
  NewsListInitial() : super(newsList: []);
}

class NewsListLoading extends NewsListState {
  NewsListLoading() : super(newsList: []);
}

class NewsListLoaded extends NewsListState {
  NewsListLoaded({required List<News> newsList, bool hasReachedMax = false})
    : super(newsList: newsList, hasReachedMax: hasReachedMax);
}

class NewsListError extends NewsListState {
  final String message;

  NewsListError({required this.message}) : super(newsList: []);
}

// Bloc
class NewsListBloc extends Bloc<NewsListEvent, NewsListState> {
  final GetNewsList getNewsList;
  int currentPage = 1;

  NewsListBloc(this.getNewsList) : super(NewsListInitial()) {
    on<LoadNewsList>((event, emit) async {
      emit(NewsListLoading());
      try {
        final List<News> newsList = await getNewsList.execute(page: event.page);
        emit(NewsListLoaded(newsList: newsList));
      } catch (e) {
        emit(NewsListError(message: e.toString()));
      }
    });

    on<LoadMoreNews>((event, emit) async {
      if (state is NewsListLoaded) {
        try {
          final List<News> moreNews = await getNewsList.execute(
            page: event.page,
          );
          final bool hasReachedMax = moreNews.isEmpty;
          final List<News> updatedNewsList = List.of(state.newsList)
            ..addAll(moreNews);
          emit(
            NewsListLoaded(
              newsList: updatedNewsList,
              hasReachedMax: hasReachedMax,
            ),
          );
        } catch (e) {
          emit(NewsListError(message: e.toString()));
        }
      }
    });
  }
}
