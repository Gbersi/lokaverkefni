
import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(color: Colors.blue),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    appBarTheme: const AppBarTheme(color: Colors.blueGrey),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
  static final customTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.purple,
    scaffoldBackgroundColor: Colors.purple.shade50,
    appBarTheme: const AppBarTheme(color: Colors.purple),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.purple),
    ),
  );
}


class TransitionExample extends StatelessWidget {
  const TransitionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smooth Transitions")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => SecondPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(position: offsetAnimation, child: child);
                },
              ),
            );
          },
          child: const Text("Go to Second Page"),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second Page")),
      body: const Center(child: Text("This is the second page.")),
    );
  }
}
