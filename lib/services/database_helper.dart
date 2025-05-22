import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        authors TEXT NOT NULL,
        description TEXT,
        publisher TEXT,
        publishedDate TEXT,
        isbn TEXT,
        thumbnailUrl TEXT,
        isFavorite INTEGER DEFAULT 0,
        pageCount INTEGER DEFAULT 0,
        currentPage INTEGER DEFAULT 0
      )
    ''');
  }

  // CRUD Operations

  // Create
  Future<int> insertBook(Book book) async {
    final db = await instance.database;
    return await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read
  Future<Book?> getBook(String id) async {
    final db = await instance.database;
    final maps = await db.query('books', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    }
    return null;
  }

  // Check if a book exists by ISBN
  Future<Book?> getBookByIsbn(String isbn) async {
    final db = await instance.database;
    final maps = await db.query('books', where: 'isbn = ?', whereArgs: [isbn]);

    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    }
    return null;
  }

  // Get all books
  Future<List<Book>> getAllBooks() async {
    final db = await instance.database;
    final result = await db.query('books');
    return result.map((json) => Book.fromMap(json)).toList();
  }

  // Get favorite books
  Future<List<Book>> getFavoriteBooks() async {
    final db = await instance.database;
    final result = await db.query(
      'books',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return result.map((json) => Book.fromMap(json)).toList();
  }

  // Update
  Future<int> updateBook(Book book) async {
    final db = await instance.database;
    return await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // Toggle favorite status
  Future<int> toggleFavorite(String id) async {
    final db = await instance.database;
    final book = await getBook(id);
    if (book != null) {
      final newStatus = book.isFavorite ? 0 : 1;
      return await db.update(
        'books',
        {'isFavorite': newStatus},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    return 0;
  }

  // Delete
  Future<int> deleteBook(String id) async {
    final db = await instance.database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
