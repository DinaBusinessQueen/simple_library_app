import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_library_app/services/google_books_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _bookProvider = Provider.of<GoogleBooksApi>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Библиотека', style: TextStyle(fontSize: 25)),
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
              controller: TextEditingController(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for books',
                labelStyle: TextStyle(
                  color: Color.fromARGB(
                    255,
                    3,
                    131,
                    29,
                  ), // Set the color you want here
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                    color: Color.fromARGB(255, 3, 131, 29),
                  ),
                  onPressed: () {
                    _bookProvider.search(
                      '',
                    ); // TODO: Передать текст из TextField
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('book $index'),

                  onTap: () {
                    // TODO: Сделать переход на страницу деталей книги
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
