import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/news_list_bloc.dart';
import '../../domain/entities/news.dart';
import 'news_detail_page.dart';
import '../widgets/news_card.dart';
import '../blocs/news_detail_cubit.dart';

class NewsSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<NewsListBloc, NewsListState>(
      builder: (context, state) {
        if (state is NewsListLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is NewsListLoaded) {
          final results =
              state.newsList
                  .where((news) => news.title.contains(query))
                  .toList();
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final News news = results[index];
              return NewsCard(
                news: news,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BlocProvider(
                            create: (context) => NewsDetailCubit(news),
                            child: NewsDetailPage(),
                          ),
                    ),
                  );
                },
              );
            },
          );
        } else if (state is NewsListError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('No news found'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
