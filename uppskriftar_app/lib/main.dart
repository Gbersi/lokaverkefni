import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './models/meal.dart';
import './screens/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Hive.initFlutter();


  Hive.registerAdapter(MealAdapter());


  if (!Hive.isBoxOpen('userRecipes')) {
    await Hive.openBox<Meal>('userRecipes');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Recipes App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const TabsScreen(),
    );
  }
}


