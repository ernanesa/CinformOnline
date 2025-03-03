import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../domain/entities/news.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onTap;

  NewsCard({required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    final formattedDate = DateFormat.yMMMd('pt_BR').format(news.date);
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: news.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(height: 8.0),
              HtmlWidget(
                news.title,
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 4.0),
              Text(formattedDate, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
