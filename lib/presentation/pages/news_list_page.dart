import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/news_list_bloc.dart';
import '../../domain/entities/news.dart';
import 'news_detail_page.dart';
import '../widgets/news_card.dart';
import '../blocs/news_detail_cubit.dart';
import 'news_search_delegate.dart';
import 'settings_page.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false;
  final List<String> _categories = ['Últimas Notícias', 'BRASIL', 'ARACAJU'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _isFetching = true;
      BlocProvider.of<NewsListBloc>(context).add(LoadMoreNews());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cinform Online News'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: NewsSearchDelegate());
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: _categories.map((category) => Tab(text: category)).toList(),
            onTap: (index) {
              String selectedCategoryName = _categories[index];
              if (selectedCategoryName == 'Últimas Notícias') {
                BlocProvider.of<NewsListBloc>(
                  context,
                ).add(LoadNewsList()); // Load all news
              } else {
                BlocProvider.of<NewsListBloc>(context).add(
                  FilterNewsByCategory(selectedCategoryName),
                ); // Filter by category
              }
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children:
              _categories.map((category) {
                return BlocBuilder<NewsListBloc, NewsListState>(
                  builder: (context, state) {
                    if (state is NewsListLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is NewsListLoaded) {
                      _isFetching = false;
                      final filteredNewsList = state.newsList;
                      filteredNewsList.sort(
                        (a, b) => b.date.compareTo(a.date),
                      ); // Sort by date
                      return LayoutBuilder(
                        builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                        ) {
                          if (constraints.maxWidth > 600) {
                            return GridView.builder(
                              controller: _scrollController,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
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
                                                  (context) =>
                                                      NewsDetailCubit(news),
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
                                                  (context) =>
                                                      NewsDetailCubit(news),
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
                );
              }).toList(),
        ),
      ),
    );
  }
}
