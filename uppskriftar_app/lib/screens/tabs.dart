import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/categories.dart';
import '../screens/favorites.dart';
import '../screens/your_recipes.dart';
import '../screens/timer_screen.dart';
import '../widgets/main_drawer.dart';
import '../providers/meals_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(mealsProvider);

    final List<Map<String, dynamic>> pages = [
      {'page': CategoriesScreen(availableMeals: availableMeals), 'title': 'Categories'},
      {'page': const FavoritesScreen(favoriteMeals: [], availableMeals: [],), 'title': 'Your Favorites'},
      {'page': const YourRecipesScreen(userRecipes: [], availableMeals: [],), 'title': 'Your Recipes'},
      {'page': const TimerScreen(availableMeals: [],), 'title': 'Timer'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[_selectedIndex]['title']),
      ),
      drawer: MainDrawer(availableMeals: availableMeals),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_selectedIndex]['page'],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Your Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
        ],
      ),
    );
  }
}
