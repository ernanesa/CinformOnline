import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/news.dart';
import '../../domain/usecases/get_news_list.dart';
import '../../domain/usecases/get_categories.dart';

// Events
abstract class NewsListEvent {}

class LoadNewsList extends NewsListEvent {
  final int page;
  final String? categoryName; // Add categoryName parameter
  LoadNewsList({this.page = 1, this.categoryName}); // Update constructor
}

class LoadMoreNews extends NewsListEvent {
  final int page;
  LoadMoreNews({this.page = 1});
}

class FilterNewsByCategory extends NewsListEvent {
  final String category;
  FilterNewsByCategory(this.category);
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
  final GetCategories getCategories;
  int currentPage = 1;

  NewsListBloc(this.getNewsList, this.getCategories)
    : super(NewsListInitial()) {
    on<LoadNewsList>((event, emit) async {
      emit(NewsListLoading());
      final result = await getNewsList.execute();
      result.fold(
        (failure) => emit(
          NewsListError(
            message:
                'Erro ao carregar a lista de notícias: ' + failure.toString(),
          ),
        ),
        (newsList) {
          List<News> filteredNewsList =
              newsList; // Inicialmente, usar a lista completa

          if (event.categoryName == 'Brasil') {
            // ✅ FILTRAR PARA "Brasil"
            filteredNewsList =
                newsList.where((news) {
                  final textLower = (news.title + news.content).toLowerCase();
                  return textLower.contains('brasil') ||
                      textLower.contains('brazil');
                }).toList();
          } else if (event.categoryName == 'Aracaju') {
            // ✅ FILTRAR PARA "Aracaju"
            filteredNewsList =
                newsList.where((news) {
                  final textLower = (news.title + news.content).toLowerCase();
                  return textLower.contains('aracaju') ||
                      textLower.contains('sergipe');
                }).toList();
          }
          // SE categoryName for null ou "Últimas Notícias", filteredNewsList será a lista completa (sem filtro)

          emit(
            NewsListLoaded(newsList: filteredNewsList),
          ); // ✅ EMITIR ESTADO COM LISTA FILTRADA (OU COMPLETA)
        },
      );
    });

    on<LoadMoreNews>((event, emit) async {
      if (state is NewsListLoaded) {
        try {
          currentPage++; // Increment currentPage before fetching more news
          print('Fetching more news...');
          final result = await getNewsList.execute(page: currentPage);
          result.fold(
            (failure) => emit(
              NewsListError(
                message:
                    'Erro ao carregar a lista de notícias: ' +
                    failure.toString(),
              ),
            ),
            (moreNews) {
              final bool hasReachedMax = moreNews.isEmpty;
              final List<News> updatedNewsList = List.of(
                (state as NewsListLoaded).newsList,
              )..addAll(moreNews);
              print('Fetched ${moreNews.length} more news items.');
              emit(
                NewsListLoaded(
                  newsList: updatedNewsList,
                  hasReachedMax: hasReachedMax,
                ),
              );
            },
          );
        } catch (e) {
          emit(
            NewsListError(
              message: 'Erro ao carregar a lista de notícias: ' + e.toString(),
            ),
          );
        }
      }
    });

    on<FilterNewsByCategory>((event, emit) async {
      emit(NewsListLoading());
      try {
        final result = await getNewsList.execute(categoryName: event.category);
        result.fold(
          (failure) => emit(
            NewsListError(
              message:
                  'Erro ao filtrar a lista de notícias: ' + failure.toString(),
            ),
          ),
          (filteredNewsList) {
            emit(NewsListLoaded(newsList: filteredNewsList));
          },
        );
      } catch (e) {
        emit(
          NewsListError(
            message: 'Erro ao filtrar a lista de notícias: ' + e.toString(),
          ),
        );
      }
    });
  }

  Future<List<String>> fetchCategories() async {
    try {
      return await getCategories.execute();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
