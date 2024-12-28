import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/tabs.dart';
import 'screens/filters.dart';
import 'screens/your_recipes.dart';
import 'screens/meal_details.dart';
import 'models/meal.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uppskriftar App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const TabsScreen(), // Home screen
        '/filters': (ctx) => const FiltersScreen(), // Filters screen
        '/your-recipes': (ctx) => const YourRecipesScreen(), // Your Recipes screen
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/meal-details') {
          final meal = settings.arguments as Meal;
          return MaterialPageRoute(
            builder: (ctx) => MealDetailsScreen(meal: meal),
          );
        }
        return null;
      },
    );
  }
}
