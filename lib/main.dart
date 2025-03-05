import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'data/datasources/news_remote_data_source.dart';
import 'data/datasources/news_local_data_source.dart';
import 'data/repositories/news_repository_impl.dart';
import 'domain/usecases/get_news_list.dart';
import 'presentation/blocs/news_list_bloc.dart';
import 'presentation/pages/news_list_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'core/utils/logger.dart';
import 'package:cinform_online/domain/usecases/get_categories.dart';
import 'package:provider/provider.dart';
import 'core/utils/theme_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize(); // Inicialize o SDK do AdMob
  AppLogger.init();

  final apiClient = ApiClient();
  final newsRemoteDataSource = NewsRemoteDataSource(apiClient: apiClient);
  final newsLocalDataSource = NewsLocalDataSource();
  final networkInfo = NetworkInfo(Connectivity());
  final newsRepository = NewsRepositoryImpl(
    newsRemoteDataSource,
    newsLocalDataSource,
    networkInfo,
  );
  final getNewsList = GetNewsList(newsRepository);
  final getCategories = GetCategories(newsRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(
          create:
              (context) =>
                  NewsListBloc(getNewsList, getCategories)..add(LoadNewsList()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Cinform Online News',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.currentTheme,
          home: NewsHomePage(),
          // CustomSplashScreen(), // Defina CustomSplashScreen como a tela inicial
        );
      },
    );
  }
}

class NewsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removido o AppBar para evitar duplicação
      body: NewsListPage(),
    );
  }
}
