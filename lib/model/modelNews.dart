class News {
  final String id;
  final String source;
  final String author;
  final String title;
  final String content;
  final String link;
  final String coverImage;
  final DateTime publishedDate;


  News(
    this.id,
    this.source,
    this.author,
    this.title,
    this.content,
    this.link,
    this.coverImage,
    this.publishedDate,
  );

  factory News.fromJson(dynamic json) {
    return News(
      json['id'] as String,
      json['source']['name'] as String,
      json['author'] as String,
      json['title'] as String,
      json['content'] as String,
      json['url'] as String,
      json['urlToImage'] as String,
      DateTime.parse(json['publishedAt'] as String),
    );
  }
}
