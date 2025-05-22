import 'package:flutter/foundation.dart';
import '../services/database_helper.dart';
import '../models/book.dart';

class UserService extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Book> _favoriteBooks = [];
  // TODO: использовать в будущем для хранения данных текущего пользователя
  String? _currentUserId;

  UserService() {
    // Initialize with "anonymous" user for now
    _currentUserId = 'anonymous';
    // Load favorite books when service is created
    loadFavoriteBooks();
  }

  // Getter for favorite books
  List<Book> get favoriteBooks => _favoriteBooks;

  // Load all favorite books from the database
  Future<void> loadFavoriteBooks() async {
    _favoriteBooks = await _databaseHelper.getFavoriteBooks();
    notifyListeners();
  }

  // Toggle the favorite status of a book
  Future<void> toggleFavorite(Book book) async {
    // Check if the book is already in our database
    Book? existingBook = await _databaseHelper.getBook(book.id);

    if (existingBook == null) {
      // Book doesn't exist in database, add it with favorite status
      await _databaseHelper.insertBook(book.copyWith(isFavorite: true));
    } else {
      // Book exists, toggle its favorite status
      await _databaseHelper.toggleFavorite(book.id);
    }

    // Reload favorites after change
    await loadFavoriteBooks();
  }

  // Check if a book is favorite
  Future<bool> isBookFavorite(String bookId) async {
    final book = await _databaseHelper.getBook(bookId);
    return book?.isFavorite ?? false;
  }

  // Add a book to favorites
  Future<void> addToFavorites(Book book) async {
    Book? existingBook = await _databaseHelper.getBook(book.id);

    if (existingBook == null) {
      // Book doesn't exist in database, add it with favorite status true
      await _databaseHelper.insertBook(book.copyWith(isFavorite: true));
    } else if (!existingBook.isFavorite) {
      // Book exists but not favorite, update favorite status
      await _databaseHelper.updateBook(existingBook.copyWith(isFavorite: true));
    }

    await loadFavoriteBooks();
  }

  // Remove a book from favorites
  Future<void> removeFromFavorites(String bookId) async {
    Book? existingBook = await _databaseHelper.getBook(bookId);

    if (existingBook != null && existingBook.isFavorite) {
      // Update the book to not be a favorite
      await _databaseHelper.updateBook(
        existingBook.copyWith(isFavorite: false),
      );
      await loadFavoriteBooks();
    }
  }

  // Future methods for user account functionality

  // Method to set current user when login is implemented
  Future<void> setCurrentUser(String userId) async {
    _currentUserId = userId;
    await loadFavoriteBooks(); // Load favorites for the new user
  }

  // Method for when a user logs out
  Future<void> clearCurrentUser() async {
    _currentUserId = 'anonymous';
    await loadFavoriteBooks(); // Reset to anonymous favorites
  }
}
