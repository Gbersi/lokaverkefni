import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  final String title;
  final List<Meal> meals;

  const MealsScreen({
    super.key,
    required this.title,
    required this.meals,
  });

  void _selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).pushNamed(
      '/meal-details',
      arguments: meal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: meals.isEmpty
          ? const Center(
        child: Text('No meals found for this category or filters.'),
      )
          : ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) {
          final meal = meals[index];
          return MealItem(
            meal: meal,
            onSelectMeal: () => _selectMeal(context, meal),
          );
        },
      ),
    );
  }
}
