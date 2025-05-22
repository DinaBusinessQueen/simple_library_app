import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_library_app/constants/app_constants.dart';
import 'package:simple_library_app/services/google_books_api.dart';
import 'package:simple_library_app/services/user_service.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoogleBooksApi()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
