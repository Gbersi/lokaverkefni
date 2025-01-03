import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/meals_provider.dart';
import '../models/meal.dart';
import '../models/meal_enums.dart'; // Import enums

class AddRecipeScreen extends ConsumerWidget {
  const AddRecipeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsNotifier = ref.read(mealsProvider.notifier);
    final titleController = TextEditingController();
    final ingredientsController = TextEditingController();
    final stepsController = TextEditingController();

    Affordability selectedAffordability = Affordability.affordable;
    Complexity selectedComplexity = Complexity.simple;

    void _saveRecipe() {
      if (titleController.text.isEmpty ||
          ingredientsController.text.isEmpty ||
          stepsController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      final newMeal = Meal(
        id: const Uuid().v4(),
        categories: ['your-recipes'], // Assign to "Your Recipes" category
        title: titleController.text,
        imageUrl: 'https://via.placeholder.com/150', // Placeholder image
        ingredients: ingredientsController.text.split(','),
        steps: stepsController.text.split('.'),
        duration: 30,
        affordability: selectedAffordability,
        complexity: selectedComplexity,
        isGlutenFree: false,
        isLactoseFree: false,
        isVegetarian: false,
        isVegan: false,
      );

      mealsNotifier.addMeal(newMeal);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients (comma-separated)'),
            ),
            TextField(
              controller: stepsController,
              decoration: const InputDecoration(labelText: 'Steps (period-separated)'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Affordability>(
              value: selectedAffordability,
              decoration: const InputDecoration(labelText: 'Affordability'),
              items: Affordability.values.map((affordability) {
                return DropdownMenuItem(
                  value: affordability,
                  child: Text(affordability.name),
                );
              }).toList(),
              onChanged: (value) {
                selectedAffordability = value!;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Complexity>(
              value: selectedComplexity,
              decoration: const InputDecoration(labelText: 'Complexity'),
              items: Complexity.values.map((complexity) {
                return DropdownMenuItem(
                  value: complexity,
                  child: Text(complexity.name),
                );
              }).toList(),
              onChanged: (value) {
                selectedComplexity = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: const Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
