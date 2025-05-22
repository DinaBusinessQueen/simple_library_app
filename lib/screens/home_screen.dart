import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_library_app/constants/app_constants.dart';
import '../services/google_books_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      final bookProvider = Provider.of<GoogleBooksApi>(context, listen: false);
      bookProvider.search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<GoogleBooksApi>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppConstants.appName, style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.green[700],
        toolbarHeight: 70,
        elevation: 5,
        shadowColor: Colors.green[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      body: Column(
        children: [
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for books',
                hintText: 'Enter a book title, author, or subject',
                labelStyle: TextStyle(color: Color.fromARGB(255, 3, 131, 29)),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                    color: Color.fromARGB(255, 3, 131, 29),
                  ),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child:
                bookProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : bookProvider.books.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Search for books to get started',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: bookProvider.books.length,
                      itemBuilder: (context, index) {
                        final book = bookProvider.books[index];
                        final volumeInfo = book['volumeInfo'] ?? {};
                        final imageLinks = volumeInfo['imageLinks'] ?? {};
                        final thumbnail = imageLinks['thumbnail'];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading:
                                thumbnail != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        thumbnail,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
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
                              volumeInfo['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  volumeInfo['authors'] != null
                                      ? volumeInfo['authors'].join(', ')
                                      : 'Unknown Author',
                                  style: TextStyle(color: Colors.green[800]),
                                ),
                                if (volumeInfo['publisher'] != null)
                                  Text(
                                    volumeInfo['publisher'],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                            onTap: () {
                              // TODO: Navigate to book details
                              /*
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetails(book: book),
                                  ),
                                );
                                */
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
