import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../utils/recipe_storage.dart';
import './add_recipe.dart';

class YourRecipesScreen extends StatefulWidget {
  const YourRecipesScreen({super.key});

  @override
  _YourRecipesScreenState createState() => _YourRecipesScreenState();
}

class _YourRecipesScreenState extends State<YourRecipesScreen> {
  List<Meal> _userRecipes = [];

  @override
  void initState() {
    super.initState();
    _initializeAndLoadRecipes();
  }

  Future<void> _initializeAndLoadRecipes() async {
    await RecipeStorage.initialize();
    final recipes = RecipeStorage.getRecipes();
    setState(() {
      _userRecipes = recipes;
    });
  }

  void _addRecipe(Meal newRecipe) async {
    _userRecipes.add(newRecipe);
    await RecipeStorage.saveRecipes(_userRecipes);
    setState(() {});
  }

  void _removeRecipe(String recipeId) async {
    _userRecipes.removeWhere((meal) => meal.id == recipeId);
    await RecipeStorage.saveRecipes(_userRecipes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newRecipe = await Navigator.of(context).push<Meal>(
                MaterialPageRoute(
                  builder: (ctx) => const AddRecipeScreen(),
                ),
              );
              if (newRecipe != null) {
                _addRecipe(newRecipe);
              }
            },
          ),
        ],
      ),
      body: _userRecipes.isEmpty
          ? const Center(
        child: Text('No recipes added yet! Tap "+" to add one.'),
      )
          : ListView.builder(
        itemCount: _userRecipes.length,
        itemBuilder: (ctx, index) {
          final recipe = _userRecipes[index];
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text(
              recipe.ingredients.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeRecipe(recipe.id),
            ),
          );
        },
      ),
    );
  }
}
