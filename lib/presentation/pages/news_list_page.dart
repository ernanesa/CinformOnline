import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/news_list_bloc.dart';
import '../../domain/entities/news.dart';
import 'news_detail_page.dart';
import '../widgets/news_card.dart';
import '../blocs/news_detail_cubit.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false;
  String? _selectedCategory;
  final List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategories();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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

  void _fetchCategories() async {
    final categories =
        await BlocProvider.of<NewsListBloc>(context).fetchCategories();
    if (mounted) {
      setState(() {
        _categories.clear(); // Clear existing categories before adding new ones
        _categories.addAll(categories);
      });
    }
  }

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
          DropdownButton<String>(
            hint: Text('Select Category'),
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
                BlocProvider.of<NewsListBloc>(
                  context,
                ).add(FilterNewsByCategory(newValue!));
              });
            },
            items:
                _categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            height: 50.0,
            alignment: Alignment.center,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                        BlocProvider.of<NewsListBloc>(
                          context,
                        ).add(FilterNewsByCategory(_selectedCategory!));
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          if (state is NewsListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewsListLoaded) {
            _isFetching = false;
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 600) {
                  return GridView.builder(
                    controller: _scrollController,
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
                } else {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.newsList.length,
                    itemBuilder: (context, index) {
                      final News news = state.newsList[index];
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
