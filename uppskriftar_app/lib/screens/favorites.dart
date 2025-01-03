import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> favoriteMeals;
  final List<Meal> availableMeals;

  const FavoritesScreen({
    super.key,
    required this.favoriteMeals,
    required this.availableMeals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
      ),
      drawer: MainDrawer(availableMeals: availableMeals),
      body: favoriteMeals.isEmpty
          ? const Center(
        child: Text('No favorites yet! Add some!'),
      )
          : ListView.builder(
        itemCount: favoriteMeals.length,
        itemBuilder: (ctx, index) {
          final meal = favoriteMeals[index];
          return MealItem(
            meal: meal,
            onSelectMeal: () {
              Navigator.of(context).pushNamed(
                '/meal-details',
                arguments: meal,
              );
            },
          );
        },
      ),
    );
  }
}
