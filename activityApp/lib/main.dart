import 'package:flutter/material.dart';
import 'main_menu.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Family Game Night',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.black54,
          centerTitle: true,
        ),
      ),
      home: const MainMenu(),
    ),
  );
}



