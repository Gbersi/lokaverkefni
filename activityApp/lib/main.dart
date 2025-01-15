import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase/app.dart';
import 'firebase_options.dart';
import 'providers/game_provider.dart';

const clientId = 'AIzaSyBvVEzZMZIjrvaWoVqIw0JEl6jquY1KayA';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()), // Add GameProvider
      ],
      child: const MyApp(),
    ),
  );
}
