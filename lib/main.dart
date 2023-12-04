import 'package:flutter/material.dart';

import 'Views/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple[100]!),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}