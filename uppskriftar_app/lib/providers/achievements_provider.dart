import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// A global context for showing SnackBar (ensure it is set in your app's main widget tree)
late BuildContext globalContext;

class Achievement {
  final String id;
  final String title;
  final String description;
  final int target;
  int progress;
  bool unlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    this.progress = 0,
    this.unlocked = false,
  });
}

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  AchievementsNotifier()
      : super([
    Achievement(
      id: 'favorite1',
      title: 'First Favorite',
      description: 'Add your first recipe to favorites.',
      target: 1,
    ),
    Achievement(
      id: 'favorite5',
      title: 'Favorite Collector',
      description: 'Add 5 recipes to favorites.',
      target: 5,
    ),
    Achievement(
      id: 'recipe1',
      title: 'First Recipe Added',
      description: 'Add your first recipe to the app.',
      target: 1,
    ),
    Achievement(
      id: 'filter1',
      title: 'Filter User',
      description: 'Use filters for the first time.',
      target: 1,
    ),
    Achievement(
      id: 'timer1',
      title: 'Timer Master',
      description: 'Start your first cooking timer.',
      target: 1,
    ),
  ]);

  void incrementProgress(String id) {
    final index = state.indexWhere((achievement) => achievement.id == id);
    if (index != -1) {
      final achievement = state[index];
      if (!achievement.unlocked) {
        achievement.progress++;
        if (achievement.progress >= achievement.target) {
          achievement.unlocked = true;
          _notifyAchievementUnlocked(achievement);
        }
        state = [...state];
      }
    }
  }

  void _notifyAchievementUnlocked(Achievement achievement) {
    // Display a SnackBar to notify the user
    ScaffoldMessenger.of(globalContext).showSnackBar(
      SnackBar(
        content: Text('Achievement Unlocked: ${achievement.title}!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

final achievementsProvider =
StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier();
});
