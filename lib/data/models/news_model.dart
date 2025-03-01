import 'package:hive/hive.dart';
import 'package:html_unescape/html_unescape.dart';
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
  final DateTime date;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final String? imagePath;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
    this.imagePath,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    return NewsModel(
      id: json['id'] as int,
      title: unescape.convert(json['title']['rendered'] as String),
      content: unescape.convert(json['content']['rendered'] as String),
      date: DateTime.parse(json['date'] as String),
      imageUrl:
          json['_embedded']['wp:featuredmedia'][0]['source_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': {'rendered': title},
      'content': {'rendered': content},
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  NewsModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    String? imageUrl,
    String? imagePath,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  News toEntity() {
    return News(
      id: id,
      title: title,
      content: content,
      date: date,
      imageUrl: imageUrl,
    );
  }

  @override
  String toString() {
    return 'NewsModel{id: $id, title: $title, content: $content, date: $date, imageUrl: $imageUrl, imagePath: $imagePath}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          date == other.date &&
          imageUrl == other.imageUrl &&
          imagePath == other.imagePath;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      date.hashCode ^
      imageUrl.hashCode ^
      imagePath.hashCode;
}
