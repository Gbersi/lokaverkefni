import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meal = ModalRoute.of(context)!.settings.arguments as Meal;
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final isFavorite = ref.watch(favoritesProvider).contains(meal);

    void toggleFavorite() {
      favoritesNotifier.toggleFavorite(meal);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorite
              ? 'Removed from Favorites'
              : 'Added to Favorites'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          FavoriteButton(isFavorite: isFavorite, onPressed: toggleFavorite),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              meal.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            ...meal.ingredients.map((ingredient) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('- $ingredient'),
            )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            ...meal.steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('$step'),
            )),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animate() {
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 6.28,
            child: Icon(
              widget.isFavorite ? Icons.star : Icons.star_border,
              color: widget.isFavorite ? Colors.yellow : Colors.grey,
            ),
          );
        },
      ),
      onPressed: () {
        widget.onPressed();
        _animate();
      },
    );
  }
}
