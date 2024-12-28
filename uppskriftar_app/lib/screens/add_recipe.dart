import 'package:flutter/material.dart';
import '../models/meal.dart';

class AddRecipeScreen extends StatefulWidget {
  final Function(Meal) onAddRecipe;

  const AddRecipeScreen({super.key, required this.onAddRecipe});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  List<String> _ingredients = [];
  List<String> _steps = [];
  Complexity _complexity = Complexity.simple;
  Affordability _affordability = Affordability.affordable;

  void _submitRecipe() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final newMeal = Meal(
      id: DateTime.now().toString(),
      categories: ['your-recipes'],
      title: _title,
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_Ul8M1wqH2LGhSZ34TfwSsGUmXMKsJPtVFQ&s',
      ingredients: _ingredients,
      steps: _steps,
      duration: 30,
      complexity: _complexity,
      affordability: _affordability,
      isGlutenFree: false,
      isLactoseFree: false,
      isVegan: false,
      isVegetarian: false,
    );

    widget.onAddRecipe(newMeal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ingredients (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one ingredient.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _ingredients = value!.split(',').map((e) => e.trim()).toList();
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Steps (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one step.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _steps = value!.split(',').map((e) => e.trim()).toList();
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Complexity>(
                  value: _complexity,
                  decoration: const InputDecoration(
                    labelText: 'Complexity',
                    border: OutlineInputBorder(),
                  ),
                  items: Complexity.values
                      .map((complexity) => DropdownMenuItem(
                    value: complexity,
                    child: Text(complexity.name),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _complexity = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Affordability>(
                  value: _affordability,
                  decoration: const InputDecoration(
                    labelText: 'Affordability',
                    border: OutlineInputBorder(),
                  ),
                  items: Affordability.values
                      .map((affordability) => DropdownMenuItem(
                    value: affordability,
                    child: Text(affordability.name),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _affordability = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitRecipe,
                  child: const Text('Add Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
