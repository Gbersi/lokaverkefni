import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/meal.dart';
import '../models/meal_enums.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  String selectedComplexity = 'Simple';
  String selectedAffordability = 'Affordable';

  void saveRecipe() async {
    final title = titleController.text;
    final ingredients = ingredientsController.text.split(',');
    final steps = stepsController.text.split('.');
    final imageUrl = imageUrlController.text;

    if (title.isEmpty ||
        ingredients.isEmpty ||
        steps.isEmpty ||
        imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Map dropdown values to enums
    final complexity = Complexity.values.firstWhere(
            (c) => c.toString().split('.').last.toLowerCase() == selectedComplexity.toLowerCase());
    final affordability = Affordability.values.firstWhere(
            (a) => a.toString().split('.').last.toLowerCase() == selectedAffordability.toLowerCase());

    // Create a Meal object
    final newMeal = Meal(
      id: DateTime.now().toString(), // Unique ID
      categories: ['your-recipes'], // Default category for user-added recipes
      title: title,
      imageUrl: imageUrl,
      ingredients: ingredients.map((e) => e.trim()).toList(),
      steps: steps.map((e) => e.trim()).toList(),
      duration: 30, // Default duration (or add a field for this if needed)
      affordability: affordability,
      complexity: complexity,
      isGlutenFree: false, // Set default or add fields for these
      isVegan: false,
      isVegetarian: false,
      isLactoseFree: false,
    );

    // Save the recipe using Hive
    final Box<Meal> mealBox = Hive.box<Meal>('recipes');
    await mealBox.add(newMeal);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe added successfully!')),
    );

    // Clear fields
    titleController.clear();
    ingredientsController.clear();
    stepsController.clear();
    imageUrlController.clear();
    setState(() {
      selectedComplexity = 'Simple';
      selectedAffordability = 'Affordable';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients (comma-separated)',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stepsController,
                decoration: const InputDecoration(
                  labelText: 'Steps (period-separated)',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Enter a valid image URL',
                ),
              ),
              const SizedBox(height: 16),
              if (imageUrlController.text.isNotEmpty)
                Image.network(
                  imageUrlController.text,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Invalid image URL. Please enter a valid one.',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Complexity'),
                value: selectedComplexity,
                items: ['Simple', 'Medium', 'Hard'].map((complexity) {
                  return DropdownMenuItem(
                    value: complexity,
                    child: Text(complexity),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedComplexity = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Affordability'),
                value: selectedAffordability,
                items: ['Affordable', 'Pricey', 'Luxurious'].map((affordability) {
                  return DropdownMenuItem(
                    value: affordability,
                    child: Text(affordability),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAffordability = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveRecipe,
                child: const Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
