import 'package:flutter/material.dart';
import '../screens/categories.dart';
import '../screens/favorites.dart';
import '../screens/your_recipes.dart';
import '../screens/timer_screen.dart';
import '../models/meal.dart';

class MainDrawer extends StatelessWidget {
  final List<Meal> availableMeals;

  const MainDrawer({super.key, required this.availableMeals});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Navigation'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => CategoriesScreen(availableMeals: availableMeals),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Your Favorites'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => const FavoritesScreen(favoriteMeals: [], availableMeals: [],),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Your Recipes'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => const YourRecipesScreen(userRecipes: [], availableMeals: [],),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Timer'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => const TimerScreen(availableMeals: [],),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

