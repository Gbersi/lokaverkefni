import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/categories.dart';
import '../screens/favorites.dart';
import '../screens/your_recipes.dart';
import '../screens/timer_screen.dart';
import '../screens/filters.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedIndex = 0;

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const CategoriesScreen(), // No need to pass availableMeals
      const FavoritesScreen(),
      const YourRecipesScreen(),
      const TimerScreen(),
    ];

    final List<String> titles = [
      'Categories',
      'Your Favorites',
      'Your Recipes',
      'Timer',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        actions: [
          if (_selectedIndex == 0)
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
      drawer: MainDrawer(setSelectedIndex: _setSelectedIndex),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        currentIndex: _selectedIndex,
        onTap: _setSelectedIndex,
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
