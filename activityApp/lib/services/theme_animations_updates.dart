import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(color: Colors.blue, elevation: 0),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    appBarTheme: const AppBarTheme(color: Colors.blueGrey, elevation: 0),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static final customTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.redAccent,
    scaffoldBackgroundColor: Colors.green.shade50,
    appBarTheme: const AppBarTheme(color: Colors.pinkAccent, elevation: 0),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  // Dynamic Background Colors
  static const lightBackgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const darkBackgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF1E1E1E), Color(0xFF424242)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const customBackgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFCD21CD), Color(0xC8F54187)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
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
                pageBuilder: (context, animation, secondaryAnimation) => const SecondPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOutCubic;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
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
      body: const Center(
        child: Text(
          "This is the second page.",
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }
}
