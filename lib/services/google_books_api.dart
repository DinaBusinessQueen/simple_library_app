import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoogleBooksApi extends ChangeNotifier {
  List books = []; // List to store fetched books data.
  bool isLoading = false; // Boolean to indicate loading state.

  final String apiKey =
      'AIzaSyDwrwmcYoCyNaqZtLl9OvcQWZ77YsSELk4'; // Google Books API key.

  // Function to search books based on user query
  Future<void> search(String query) async {
    // URL of the Google Books API, with the query string and API key
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}&key=$apiKey';

    // Set loading state to true (start fetching), notify listeners
    isLoading = true;
    notifyListeners(); // Notify the UI to show a loading spinner.

    try {
      // Make HTTP GET request to Google Books API
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Parse the JSON response.
        books = data['items'] ?? [];
      } else {
        books = []; // If request fails, set the books list to empty.
      }
    } catch (e) {
      // If there's an exception
      books = [];
    }

    // Set loading state to false (done fetching), notify listeners
    isLoading = false;
    notifyListeners(); // Notify the UI to remove the loading spinner.
  }
}
