import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal.dart';
import '../screens/add_recipe.dart';
import '../screens/meal_details.dart';

class YourRecipesScreen extends StatelessWidget {
  const YourRecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Meal>('recipes').listenable(),
        builder: (context, Box<Meal> mealBox, _) {
          final userRecipes = mealBox.values.where((meal) {
            return meal.categories.contains('your-recipes');
          }).toList();

          if (userRecipes.isEmpty) {
            return const Center(
              child: Text('No recipes added yet! Start adding your favorite recipes!'),
            );
          }

          return ListView.builder(
            itemCount: userRecipes.length,
            itemBuilder: (context, index) {
              final recipe = userRecipes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: recipe.imageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      recipe.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50),
                    ),
                  )
                      : const Icon(Icons.fastfood, size: 50),
                  title: Text(recipe.title),
                  subtitle: Text('Complexity: ${recipe.complexity.name}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Recipe'),
                          content: const Text('Are you sure you want to delete this recipe?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed ?? false) {
                        mealBox.deleteAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recipe deleted!')),
                        );
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MealDetailsScreen(meal: recipe),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddRecipeScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Recipe',
      ),
    );
  }
}
