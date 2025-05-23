import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../services/user_service.dart';
import '../widgets/bookmark_button.dart';
import 'book_details_page.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем избранные книги при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserService>(context, listen: false).loadFavoriteBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные книги'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          final favoriteBooks = userService.favoriteBooks;

          if (favoriteBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'У вас пока нет избранных книг',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Возврат на экран поиска
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Искать книги'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteBooks.length,
            itemBuilder: (context, index) {
              final book = favoriteBooks[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading:
                      book.thumbnailUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              book.thumbnailUrl!,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    width: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.book),
                                  ),
                            ),
                          )
                          : Container(
                            width: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.book),
                          ),
                  title: Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.authors,
                        style: TextStyle(color: Colors.green[800]),
                      ),
                      if (book.publisher != null)
                        Text(
                          book.publisher!,
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: BookmarkButton(book: book, size: 20),
                  onTap: () {
                    // Создаем Map объект, который будет имитировать формат данных с Google Books API
                    final bookMap = {
                      'id': book.id,
                      'volumeInfo': {
                        'title': book.title,
                        'authors': book.authors.split(', '),
                        'description': book.description,
                        'publisher': book.publisher,
                        'publishedDate': book.publishedDate,
                        'industryIdentifiers':
                            book.isbn != null
                                ? [
                                  {'type': 'ISBN_13', 'identifier': book.isbn},
                                ]
                                : [],
                        'imageLinks':
                            book.thumbnailUrl != null
                                ? {'thumbnail': book.thumbnailUrl}
                                : {},
                        'pageCount': book.pageCount,
                      },
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(book: bookMap),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
