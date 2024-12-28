import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Center(
              child: Text(
                'Uppskriftar App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text('Meals'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Your Recipes'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/your-recipes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Filters'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/filters');
            },
          ),
        ],
      ),
    );
  }
}
