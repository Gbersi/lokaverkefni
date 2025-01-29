import 'package:activityapp/screens/main_menu.dart';
import 'package:activityapp/services/theme_animations_updates.dart';
import 'package:activityapp/services/theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase/auth_gate.dart';
import 'firebase_options.dart';
import 'providers/game_provider.dart';
import 'providers/player_provider.dart';

const clientId = 'AIzaSyBvVEzZMZIjrvaWoVqIw0JEl6jquY1KayA';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Activity App',
          theme: themeNotifier.currentTheme,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasData) {
                return const MainMenu();
              } else {
                return const AuthGate();
              }
            },
          ),
        );
      },
    );
  }
}
