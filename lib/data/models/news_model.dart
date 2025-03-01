import 'package:hive/hive.dart';
import '../../domain/entities/news.dart';

part 'news_model.g.dart'; // Este arquivo será gerado

@HiveType(typeId: 0) // Use um ID único para cada tipo
class NewsModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final DateTime date;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as int,
      title: json['title']['rendered'] as String,
      content: json['content']['rendered'] as String,
      imageUrl:
          json['_embedded']['wp:featuredmedia'][0]['source_url'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': {'rendered': title},
      'content': {'rendered': content},
      '_embedded': {
        'wp:featuredmedia': [
          {'source_url': imageUrl},
        ],
      },
      'date': date.toIso8601String(),
    };
  }

  News toEntity() {
    return News(
      id: id,
      title: title,
      content: content,
      imageUrl: imageUrl,
      date: date,
    );
  }

  @override
  String toString() {
    return 'NewsModel{id: $id, title: $title, content: $content, imageUrl: $imageUrl, date: $date}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          imageUrl == other.imageUrl &&
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      imageUrl.hashCode ^
      date.hashCode;
}
