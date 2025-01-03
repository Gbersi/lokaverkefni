import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/category_grid_item.dart';
import '../widgets/main_drawer.dart';
import 'meals.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Meal> availableMeals;

  const CategoriesScreen({super.key, required this.availableMeals});

  void _selectCategory(BuildContext context, String categoryId, String categoryTitle) {
    final filteredMeals = availableMeals.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: categoryTitle,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dummyCategories = [
      {'id': 'c1', 'title': 'Italian', 'color': Colors.purple},
      {'id': 'c2', 'title': 'Quick & Easy', 'color': Colors.red},
      {'id': 'c3', 'title': 'Hamburgers', 'color': Colors.orange},
      {'id': 'c4', 'title': 'German', 'color': Colors.amber},
      {'id': 'c5', 'title': 'Light & Lovely', 'color': Colors.blue},
      {'id': 'c6', 'title': 'Exotic', 'color': Colors.green},
      {'id': 'c7', 'title': 'Breakfast', 'color': Colors.lightBlue},
      {'id': 'c8', 'title': 'Asian', 'color': Colors.lightGreen},
      {'id': 'c9', 'title': 'French', 'color': Colors.pink},
      {'id': 'c10', 'title': 'Summer', 'color': Colors.teal},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      drawer: MainDrawer(availableMeals: availableMeals),
      body: GridView(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: dummyCategories.map((catData) {
          return CategoryGridItem(
            id: catData['id'] as String,
            title: catData['title'] as String,
            color: catData['color'] as Color,
            onSelectCategory: () => _selectCategory(
              context,
              catData['id'] as String,
              catData['title'] as String,
            ),
          );
        }).toList(),
      ),
    );
  }
}
