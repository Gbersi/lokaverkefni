import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/meals_provider.dart';
import '../widgets/meal_item.dart';
import 'meal_details.dart';

class YourRecipesScreen extends ConsumerWidget {
  const YourRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealsProvider).where((meal) => meal.categories.contains('your-recipes')).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          tooltip: 'Back to Main Menu',
        ),
        title: const Text('Your Recipes'),
      ),
      body: meals.isEmpty
          ? const Center(
        child: Text('No recipes added yet.'),
      )
          : ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) {
          final meal = meals[index];
          return MealItem(
            meal: meal,
            onSelectMeal: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => MealDetailsScreen(meal: meal),
                ),
              );
            },
            onDelete: () {
              ref.read(mealsProvider.notifier).deleteMeal(meal.id);
            },
          );
        },
      ),
    );
  }
}

