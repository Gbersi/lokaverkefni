import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
      ),
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
