import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'meals.dart';
import 'package:uppskriftar_app/widgets/category_grid_item.dart';
import 'package:uppskriftar_app/models/category.dart';
import 'package:uppskriftar_app/models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  Widget build(BuildContext context) {
    final categories = [
      ...availableCategories,
      Category(
        id: 'your-recipes',
        title: 'Your Recipes',
        color: Colors.blueGrey,
      ),
    ];

    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: categories.map((category) {
        return CategoryGridItem(
          category: category,
          onSelectCategory: () {
            final filteredMeals = availableMeals
                .where((meal) => meal.categories.contains(category.id))
                .toList();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => MealsScreen(
                  title: category.title,
                  meals: filteredMeals,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
