class News {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
  });

  @override
  String toString() {
    return 'News{id: $id, title: $title, content: $content, imageUrl: $imageUrl, date: $date}';
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
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      imageUrl.hashCode ^
      date.hashCode;
} 