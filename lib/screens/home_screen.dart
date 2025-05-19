import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    // TODO: Сделать логику поиска книг
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
