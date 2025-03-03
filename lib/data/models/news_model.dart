import 'package:html_unescape/html_unescape.dart';
import '../../domain/entities/news.dart';

class NewsModel {
  final int id;
  final String title;
  final String content;
  final DateTime date;
  final String imageUrl;
  final String? imagePath;
  final String category;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
    this.imagePath,
    required this.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    String category = json['category'] as String;
    if (category == 'Uncategorized') {
      final title =
          unescape.convert(json['title']['rendered'] as String).toLowerCase();
      if (title.contains('aracaju') || title.contains('sergipe')) {
        category = 'Aracaju';
      } else if (title.contains('brasil') || title.contains('brazil')) {
        category = 'Brasil';
      }
    }
    return NewsModel(
      id: json['id'] as int,
      title: unescape.convert(json['title']['rendered'] as String),
      content: unescape.convert(json['content']['rendered'] as String),
      date: DateTime.parse(json['date'] as String),
      imageUrl:
          json['_embedded']['wp:featuredmedia'][0]['source_url'] as String,
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': {'rendered': title},
      'content': {'rendered': content},
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  NewsModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    String? imageUrl,
    String? imagePath,
    String? category,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
    );
  }

  News toEntity() {
    return News(
      id: id,
      title: title,
      content: content,
      date: date,
      imageUrl: imageUrl,
      category: category,
    );
  }

  @override
  String toString() {
    return 'NewsModel{id: $id, title: $title, content: $content, date: $date, imageUrl: $imageUrl, imagePath: $imagePath, category: $category}';
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
          imagePath == other.imagePath &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      date.hashCode ^
      imageUrl.hashCode ^
      imagePath.hashCode ^
      category.hashCode;
}
