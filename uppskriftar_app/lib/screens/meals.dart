import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';
import 'meal_details.dart';

class MealsScreen extends StatelessWidget {
  final String title;
  final List<Meal> meals;

  const MealsScreen({
    super.key,
    required this.title,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: meals.isEmpty
          ? const Center(
        child: Text('No meals found.'),
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
          );
        },
      ),
    );
  }
}
