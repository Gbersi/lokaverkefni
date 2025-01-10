import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../providers/favorites_provider.dart';
import '../models/meal.dart';
import '../screens/meal_details.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    if (favorites.isEmpty) {
      return const Center(
        child: Text('No favorites yet!'),
      );
    }

    return ListView(
      children: favorites.map((meal) {
        return ListTile(
          title: GestureDetector(
            onTap: () {
              // Navigate to MealDetailsScreen when recipe name is clicked
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => MealDetailsScreen(meal: meal),
                ),
              );
            },
            child: Text(
              meal.title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue, // Highlight clickable text
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          subtitle: Text(
            'Rating: ${meal.rating?.toStringAsFixed(1) ?? 'Not rated'}\n'
                'Note: ${meal.note ?? 'No notes added'}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => FavoriteDetailsDialog(meal: meal),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class FavoriteDetailsDialog extends StatefulWidget {
  final Meal meal;

  const FavoriteDetailsDialog({super.key, required this.meal});

  @override
  _FavoriteDetailsDialogState createState() => _FavoriteDetailsDialogState();
}

class _FavoriteDetailsDialogState extends State<FavoriteDetailsDialog> {
  final _noteController = TextEditingController();
  double? _rating;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.meal.note ?? '';
    _rating = widget.meal.rating;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Details for ${widget.meal.title}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(labelText: 'Add a note'),
          ),
          const SizedBox(height: 10),
          DropdownButton<double>(
            value: _rating,
            hint: const Text('Select rating'),
            items: List.generate(5, (i) => i + 1)
                .map((e) =>
                DropdownMenuItem(value: e.toDouble(), child: Text('$e')))
                .toList(),
            onChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final ref = ProviderScope.containerOf(context, listen: false);
            ref.read(favoritesProvider.notifier).updateNoteOrRating(
              widget.meal,
              note: _noteController.text,
              rating: _rating,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

