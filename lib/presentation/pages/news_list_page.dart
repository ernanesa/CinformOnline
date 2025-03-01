import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/news_list_bloc.dart';
import '../../domain/entities/news.dart';
import 'news_detail_page.dart';
import '../widgets/news_card.dart';
import '../blocs/news_detail_cubit.dart';

class NewsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cinform Online News'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<NewsListBloc>(context).add(LoadNewsList());
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          if (state is NewsListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewsListLoaded) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 600) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: state.newsList.length,
                    itemBuilder: (context, index) {
                      final News news = state.newsList[index];
                      return NewsCard(
                        news: news,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => NewsDetailCubit(news),
                                child: NewsDetailPage(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: state.newsList.length,
                    itemBuilder: (context, index) {
                      final News news = state.newsList[index];
                      return NewsCard(
                        news: news,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => NewsDetailCubit(news),
                                child: NewsDetailPage(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          } else if (state is NewsListError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('No news loaded'));
          }
        },
      ),
    );
  }
} 