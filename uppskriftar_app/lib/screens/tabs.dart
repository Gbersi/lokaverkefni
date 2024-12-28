import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'categories.dart';
import 'meals.dart';
import 'filters.dart';
import 'add_recipe.dart';
import '../providers/meals_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(mealsProvider);
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    final pages = [
      {
        'page': CategoriesScreen(availableMeals: availableMeals),
        'title': 'Categories',
      },
      {
        'page': MealsScreen(
          title: 'Your Favorites',
          meals: favoriteMeals,
        ),
        'title': 'Your Favorites',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[_selectedPageIndex]['title'] as String),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const FiltersScreen(),
                ),
              );
            },
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddRecipeScreen(
                onAddRecipe: (newMeal) {
                  ref.read(mealsProvider.notifier).addMeal(newMeal);
                },
              ),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
