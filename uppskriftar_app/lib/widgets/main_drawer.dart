import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final Function(int) setSelectedIndex;

  const MainDrawer({super.key, required this.setSelectedIndex});

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
              Navigator.of(context).pop(); // Close the drawer
              setSelectedIndex(0);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Your Favorites'),
            onTap: () {
              Navigator.of(context).pop();
              setSelectedIndex(1);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Your Recipes'),
            onTap: () {
              Navigator.of(context).pop();
              setSelectedIndex(2);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Timer'),
            onTap: () {
              Navigator.of(context).pop();
              setSelectedIndex(3);
            },
          ),
        ],
      ),
    );
  }
}
