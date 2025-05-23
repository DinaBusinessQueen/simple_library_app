import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart';
import '../widgets/bookmark_button.dart';

class BookDetailsPage extends StatelessWidget {
  final Map book;

  const BookDetailsPage({super.key, required this.book});

  // Function to open URLs in the browser
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Create a Uri object
    if (await canLaunchUrl(uri)) {
      // Check if the URL can be launched
      await launchUrl(uri); // Launch the URL
    } else {
      throw 'Could not launch $url'; // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final volumeInfo = book['volumeInfo'];

    //  Extract URLs
    final thumbnail =
        volumeInfo['imageLinks'] != null
            ? volumeInfo['imageLinks']['thumbnail']
            : null;

    final previewLink = volumeInfo['previewLink'];
    final downloadLink =
        book['accessInfo'] != null
            ? book['accessInfo']['pdf'] != null &&
                    book['accessInfo']['pdf']['isAvailable']
                ? book['accessInfo']['pdf']['acsTokenLink']
                : null
            : null;

    final buyLink = volumeInfo['infoLink'];

    // Convert the raw book data to a Book model for the bookmark button
    final bookModel = Book.fromGoogleBooksApi(book);

    return Scaffold(
      appBar: AppBar(
        title: Text(volumeInfo['title'] ?? 'No Title'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BookmarkButton(book: bookModel, size: 28),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image with a placeholder and error handling
            thumbnail != null
                ? FadeInImage.assetNetwork(
                  placeholder:
                      'assets/images/placeholder.png', // Path to your placeholder image
                  image: thumbnail,
                  fit: BoxFit.cover, // Adjust how the image should fit
                  imageErrorBuilder: (context, error, stackTrace) {
                    // If image fails to load, show the placeholder image
                    return Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.cover,
                    );
                  },
                )
                : const Icon(Icons.book, size: 100),
            const SizedBox(height: 16),
            Text(
              volumeInfo['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Author(s): ' +
                  (volumeInfo['authors'] != null
                      ? volumeInfo['authors'].join(', ')
                      : 'Unknown'),
            ),
            const SizedBox(height: 8),
            Text(volumeInfo['description'] ?? 'No Description'),
            const Spacer(),
            SafeArea(
              child: Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Preview Button
                  if (previewLink != null)
                    ElevatedButton(
                      onPressed: () {
                        _launchURL(previewLink);
                      },
                      child: const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(
                          right: 20,
                          left: 25,
                          top: 15,
                          bottom: 15,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  // Download Button
                  if (downloadLink != null)
                    ElevatedButton(
                      onPressed: () {
                        _launchURL(downloadLink);
                      },
                      child: const Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(
                          right: 20,
                          left: 25,
                          top: 15,
                          bottom: 15,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        _launchURL(buyLink);
                      },
                      child: const Text(
                        'More Info',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(
                          right: 20,
                          left: 25,
                          top: 15,
                          bottom: 15,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
