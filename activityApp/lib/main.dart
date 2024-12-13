import 'package:flutter/material.dart';
import 'screens/main_menu.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Family Game Night',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black54),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 5,
          backgroundColor: Color.fromARGB(253, 145, 145, 145),
          foregroundColor: Colors.black54,
          centerTitle: true,
        ),
      ),
      home:  MainMenu(),
    ),
  );
}



