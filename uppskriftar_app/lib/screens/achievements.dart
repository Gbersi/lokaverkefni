import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/achievements_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: ListView.builder(
        itemCount: achievements.length,
        itemBuilder: (ctx, index) {
          final achievement = achievements[index];
          return ListTile(
            leading: Icon(
              achievement.unlocked
                  ? Icons.emoji_events
                  : Icons.lock_outline,
              color: achievement.unlocked ? Colors.amber : Colors.grey,
            ),
            title: Text(achievement.title),
            subtitle: Text(
              '${achievement.description}\nProgress: ${achievement.progress}/${achievement.target}',
            ),
          );
        },
      ),
    );
  }
}
