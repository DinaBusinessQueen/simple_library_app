class Book {
  final String id;
  final String title;
  final String authors;
  final String? description;
  final String? publisher;
  final String? publishedDate;
  final String? isbn;
  final String? thumbnailUrl;
  final bool isFavorite;
  final int pageCount;
  final int currentPage;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.publisher,
    this.publishedDate,
    this.isbn,
    this.thumbnailUrl,
    this.isFavorite = false,
    this.pageCount = 0,
    this.currentPage = 0,
  });
  // Create a Book from Google Books API JSON
  factory Book.fromGoogleBooksApi(Map json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    // Extract ISBN-13 if available, otherwise use ISBN-10 or other identifier
    String? isbn;
    if (volumeInfo['industryIdentifiers'] != null) {
      final identifiers = volumeInfo['industryIdentifiers'] as List;
      // First try to find ISBN_13
      final isbn13 = identifiers.firstWhere(
        (id) => id['type'] == 'ISBN_13',
        orElse: () => {'identifier': null},
      );
      // If no ISBN_13, try ISBN_10
      final isbn10 = identifiers.firstWhere(
        (id) => id['type'] == 'ISBN_10',
        orElse: () => {'identifier': null},
      );
      // Use ISBN_13 if available, otherwise ISBN_10, otherwise null
      isbn = isbn13['identifier'] ?? isbn10['identifier'];
    }

    return Book(
      // Use provided id if available, otherwise use ISBN or generate a unique id
      id:
          json['id'] ??
          isbn ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: volumeInfo['title'] ?? 'Unknown Title',
      authors:
          volumeInfo['authors'] != null
              ? volumeInfo['authors'].join(', ')
              : 'Unknown Author',
      description: volumeInfo['description'],
      publisher: volumeInfo['publisher'],
      publishedDate: volumeInfo['publishedDate'],
      isbn: isbn,
      thumbnailUrl: imageLinks['thumbnail'],
      pageCount: volumeInfo['pageCount'] ?? 0,
    );
  }

  // Create a Book from a database record
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      authors: map['authors'],
      description: map['description'],
      publisher: map['publisher'],
      publishedDate: map['publishedDate'],
      isbn: map['isbn'],
      thumbnailUrl: map['thumbnailUrl'],
      isFavorite: map['isFavorite'] == 1,
      pageCount: map['pageCount'] ?? 0,
      currentPage: map['currentPage'] ?? 0,
    );
  }

  // Convert a Book to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'isbn': isbn,
      'thumbnailUrl': thumbnailUrl,
      'isFavorite': isFavorite ? 1 : 0,
      'pageCount': pageCount,
      'currentPage': currentPage,
    };
  }

  // Create a copy of this Book with modified fields
  Book copyWith({
    String? id,
    String? title,
    String? authors,
    String? description,
    String? publisher,
    String? publishedDate,
    String? isbn,
    String? thumbnailUrl,
    bool? isFavorite,
    int? pageCount,
    int? currentPage,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      description: description ?? this.description,
      publisher: publisher ?? this.publisher,
      publishedDate: publishedDate ?? this.publishedDate,
      isbn: isbn ?? this.isbn,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, authors: $authors, isFavorite: $isFavorite}';
  }
}
