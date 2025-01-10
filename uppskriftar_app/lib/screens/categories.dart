import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../providers/filters_provider.dart';
import '../screens/meals.dart';
import '../screens/meal_details.dart';
import '../screens/your_recipes.dart';
import '../screens/add_recipe.dart'; // Import Add Recipe Screen
import '../widgets/category_grid_item.dart';
import 'filters.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key, required List<Meal> availableMeals});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  String _searchQuery = ''; // State for the search query
  String _sortOption = 'popularity'; // Default sorting option
  final _focusNode = FocusNode(); // To control focus for the search bar

  void _sortRecipes(List<Meal> recipes) {
    if (_sortOption == 'popularity') {
      recipes.sort((a, b) => b.popularity.compareTo(a.popularity));
    } else if (_sortOption == 'time') {
      recipes.sort((a, b) => a.duration.compareTo(b.duration));
    } else if (_sortOption == 'alphabetical') {
      recipes.sort((a, b) => a.title.compareTo(b.title));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = ref.watch(filteredMealsProvider);

    // Apply sorting
    _sortRecipes(filteredMeals);

    // Filter by search query
    final searchResults = filteredMeals.where((meal) {
      return meal.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          meal.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();

    final categories = [
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
      {"id": "c11", "title": "Icelandic", "color": Colors.deepPurpleAccent},
      {'id': 'your-recipes', 'title': 'Your Recipes', 'color': Colors.brown},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          // Sorting dropdown
          DropdownButton<String>(
            value: _sortOption,
            icon: const Icon(Icons.sort, color: Colors.white),
            onChanged: (value) {
              setState(() {
                _sortOption = value!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: 'popularity',
                child: Text('Sort by Popularity'),
              ),
              DropdownMenuItem(
                value: 'time',
                child: Text('Sort by Cooking Time'),
              ),
              DropdownMenuItem(
                value: 'alphabetical',
                child: Text('Sort Alphabetically'),
              ),
            ],
          ),
          // Normal filters button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const FiltersScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: 'Search Recipes or Ingredients',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          if (_searchQuery.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (ctx, index) {
                  final meal = searchResults[index];
                  return ListTile(
                    leading: Image.network(
                      meal.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(meal.title),
                    subtitle: Text(
                      'Ingredients: ${meal.ingredients.join(', ')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MealDetailsScreen(meal: meal),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          if (_searchQuery.isEmpty)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: categories.length,
                itemBuilder: (ctx, index) {
                  final catData = categories[index];

                  // Check for "Your Recipes" category
                  if (catData['id'] == 'your-recipes') {
                    return CategoryGridItem(
                      id: catData['id'] as String,
                      title: catData['title'] as String,
                      color: catData['color'] as Color,
                      onSelectCategory: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const YourRecipesScreen(),
                          ),
                        );
                      },
                    );
                  }

                  // Handle other categories
                  return CategoryGridItem(
                    id: catData['id'] as String,
                    title: catData['title'] as String,
                    color: catData['color'] as Color,
                    onSelectCategory: () {
                      final categoryMeals = filteredMeals.where((meal) {
                        return meal.categories.contains(catData['id']);
                      }).toList();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MealsScreen(
                            title: catData['title'] as String,
                            meals: categoryMeals,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
