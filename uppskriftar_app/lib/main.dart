import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/meal.dart';
import 'screens/tabs.dart';
import 'screens/meal_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MealAdapter());


  await Hive.openBox<Meal>('userRecipes');
  await Hive.openBox<Meal>('favorites');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const TabsScreen(),
      routes: {
        '/meal-details': (ctx) => const MealDetailsScreen(),
      },
    );
  }
}
