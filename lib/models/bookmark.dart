class Bookmark {
  final String id;
  final String userId;
  final String bookId;
  final String title;
  final String author;
  final String? isbn;
  final String? thumbnailUrl;
  final String? description;
  final DateTime createdAt;

  Bookmark({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.title,
    required this.author,
    this.isbn,
    this.thumbnailUrl,
    this.description,
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      userId: json['userId'],
      bookId: json['bookId'],
      title: json['title'],
      author: json['author'],
      isbn: json['isbn'],
      thumbnailUrl: json['thumbnailUrl'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'title': title,
      'author': author,
      'isbn': isbn,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
