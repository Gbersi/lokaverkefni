import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';

final FlutterTts flutterTts = FlutterTts();

Future<void> speak(String text) async {
  await flutterTts.setLanguage("en-US");
  await flutterTts.setPitch(1.0);
  await flutterTts.speak(text);
}

class MealDetailsScreen extends ConsumerStatefulWidget {
  final Meal meal;

  const MealDetailsScreen({Key? key, required this.meal}) : super(key: key);

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen> {
  int? _timeRemaining;
  Timer? _timer;

  void startTimer(int duration) {
    setState(() {
      _timeRemaining = duration * 60; // Convert minutes to seconds
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining! > 0) {
        setState(() {
          _timeRemaining = _timeRemaining! - 1;
        });
      } else {
        timer.cancel();
        _showTimerCompleteDialog();
      }
    });
  }

  void _showTimerCompleteDialog() {
    speak("Timer completed. Your meal is ready!");
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Timer Complete!'),
        content: const Text('Your recipe timer has finished.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoritesProvider).contains(widget.meal);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                'Check out this recipe: ${widget.meal.title}\nIngredients: ${widget.meal.ingredients.join(', ')}\nSteps: ${widget.meal.steps.join('. ')}',
              );
            },
            tooltip: 'Share Recipe',
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              speak(
                "Recipe for ${widget.meal.title}. Ingredients: ${widget.meal.ingredients.join(', ')}. Steps: ${widget.meal.steps.join('. ')}",
              );
            },
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.yellow : null,
            ),
            onPressed: () {
              favoritesNotifier.toggleFavorite(widget.meal);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite ? 'Removed from favorites' : 'Added to favorites',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.meal.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...widget.meal.ingredients.map((ingredient) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('- $ingredient'),
            )),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...widget.meal.steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('- $step'),
            )),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  startTimer(widget.meal.duration);
                },
                icon: const Icon(Icons.timer),
                label: const Text('Start Timer'),
              ),
            ),
            if (_timeRemaining != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Time Remaining: ${_formatTime(_timeRemaining!)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
