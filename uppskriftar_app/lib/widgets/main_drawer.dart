import 'package:flutter/material.dart';

import '../screens/achievements.dart';

class MainDrawer extends StatelessWidget {
  final Function setSelectedIndex;
  final int currentIndex;

  const MainDrawer({
    super.key,
    required this.setSelectedIndex,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            selected: currentIndex == 0, // Highlight active page
            onTap: () {
              if (currentIndex != 0) {
                setSelectedIndex(0);
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Favorites'),
            selected: currentIndex == 1,
            onTap: () {
              if (currentIndex != 1) {
                setSelectedIndex(1);
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Your Recipes'),
            selected: currentIndex == 2,
            onTap: () {
              if (currentIndex != 2) {
                setSelectedIndex(2);
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Timer'),
            selected: currentIndex == 3,
            onTap: () {
              if (currentIndex != 3) {
                setSelectedIndex(3);
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Achievements'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AchievementsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
