import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../blocs/news_list_bloc.dart';
import '../../domain/entities/news.dart';
import 'news_detail_page.dart';
import '../widgets/news_card.dart';
import '../blocs/news_detail_cubit.dart';
import 'package:provider/provider.dart';
import '../../core/utils/theme_provider.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialNews();
  }

  void _loadInitialNews() {
    BlocProvider.of<NewsListBloc>(context).add(LoadNewsList());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 750 &&
        !_isFetching) {
      _isFetching = true;
      BlocProvider.of<NewsListBloc>(context).add(
        LoadMoreNews(
          page: ++BlocProvider.of<NewsListBloc>(context).currentPage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cinform Online News',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(color: Color(0xFF152D71)),
        ),
        actions: [
          IconButton(
            icon:
                themeProvider.isDarkMode
                    ? Icon(
                      Icons.light_mode,
                      color: Theme.of(context).iconTheme.color,
                      size: Theme.of(context).iconTheme.size,
                    )
                    : Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).iconTheme.color,
                      size: Theme.of(context).iconTheme.size,
                    ),
            onPressed: () {
              Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          if (state is NewsListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewsListLoaded) {
            _isFetching = false;
            final filteredNewsList = state.newsList;
            return RefreshIndicator(
              onRefresh: () async {
                final Completer<void> completer = Completer<void>();
                BlocProvider.of<NewsListBloc>(context).add(LoadNewsList());

                await Future.delayed(Duration(seconds: 1));
                completer.complete();
                return completer.future;
              },
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth > 600) {
                    return GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: filteredNewsList.length,
                      itemBuilder: (context, index) {
                        final News news = filteredNewsList[index];
                        return NewsCard(
                          news: news,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider(
                                      create:
                                          (context) => NewsDetailCubit(news),
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
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: filteredNewsList.length,
                      itemBuilder: (context, index) {
                        final News news = filteredNewsList[index];
                        return NewsCard(
                          news: news,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider(
                                      create:
                                          (context) => NewsDetailCubit(news),
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
              ),
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
