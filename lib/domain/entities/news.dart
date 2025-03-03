class News {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;
  final String category;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.category,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      title: json['title']['rendered'] as String? ?? '',
      content: json['content']['rendered'] as String? ?? '',
      imageUrl:
          json['_embedded']['wp:featuredmedia'] != null &&
                  json['_embedded']['wp:featuredmedia'].isNotEmpty
              ? json['_embedded']['wp:featuredmedia'][0]['source_url']
                      as String? ??
                  ''
              : '',
      date: DateTime.parse(json['date'] as String? ?? ''),
      category: json['category'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'News{id: $id, title: $title, content: $content, imageUrl: $imageUrl, date: $date, category: $category}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is News &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          imageUrl == other.imageUrl &&
          date == other.date &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      imageUrl.hashCode ^
      date.hashCode ^
      category.hashCode;
}
