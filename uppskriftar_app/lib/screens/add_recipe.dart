import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/meal.dart';
import '../models/meal_enums.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  Affordability _selectedAffordability = Affordability.affordable;
  Complexity _selectedComplexity = Complexity.simple;

  void _saveRecipe() {
    if (_titleController.text.isEmpty ||
        _ingredientsController.text.isEmpty ||
        _stepsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final newRecipe = Meal(
      id: const Uuid().v4(),
      categories: ['your-recipes'],
      title: _titleController.text,
      imageUrl: '',
      ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
      steps: _stepsController.text.split('.').map((e) => e.trim()).toList(),
      duration: 30,
      affordability: _selectedAffordability,
      complexity: _selectedComplexity,
      isGlutenFree: false,
      isLactoseFree: false,
      isVegetarian: false,
      isVegan: false,
    );

    Navigator.of(context).pop(newRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients (comma-separated)'),
            ),
            TextField(
              controller: _stepsController,
              decoration: const InputDecoration(labelText: 'Steps (period-separated)'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Affordability>(
              value: _selectedAffordability,
              decoration: const InputDecoration(labelText: 'Affordability'),
              items: Affordability.values.map((affordability) {
                return DropdownMenuItem(
                  value: affordability,
                  child: Text(affordability.name),
                );
              }).toList(),
              onChanged: (value) => setState(() {
                _selectedAffordability = value!;
              }),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Complexity>(
              value: _selectedComplexity,
              decoration: const InputDecoration(labelText: 'Complexity'),
              items: Complexity.values.map((complexity) {
                return DropdownMenuItem(
                  value: complexity,
                  child: Text(complexity.name),
                );
              }).toList(),
              onChanged: (value) => setState(() {
                _selectedComplexity = value!;
              }),
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
