import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../models/meal.dart';

class YourRecipesScreen extends StatelessWidget {
  final List<Meal> userRecipes;
  final List<Meal> availableMeals;

  const YourRecipesScreen({
    super.key,
    required this.userRecipes,
    required this.availableMeals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
      ),
      drawer: MainDrawer(availableMeals: availableMeals),
      body: userRecipes.isEmpty
          ? const Center(
        child: Text('No recipes added yet!'),
      )
          : ListView.builder(
        itemCount: userRecipes.length,
        itemBuilder: (ctx, index) {
          final recipe = userRecipes[index];
          return ListTile(
            title: Text(recipe.title),
            onTap: () {
              Navigator.of(context).pushNamed(
                '/meal-details',
                arguments: recipe,
              );
            },
          );
        },
      ),
    );
  }
}
