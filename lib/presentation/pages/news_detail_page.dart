import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../blocs/news_detail_cubit.dart';

class NewsDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final news = context.watch<NewsDetailCubit>().state;
    initializeDateFormatting('pt_BR', null);
    final formattedDate = DateFormat.yMMMd('pt_BR').format(news.date);
    return Scaffold(
      appBar: AppBar(title: Text('Notícias Cinform Online'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: news.imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget:
                  (context, url, error) => Icon(
                    Icons.error,
                    color: Theme.of(context).iconTheme.color,
                    size: Theme.of(context).iconTheme.size,
                  ),
            ),
            SizedBox(height: 16.0),
            HtmlWidget(
              news.title,
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8.0),
            Text(formattedDate, style: Theme.of(context).textTheme.bodySmall),
            SizedBox(height: 16.0),
            HtmlWidget(
              news.content,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
