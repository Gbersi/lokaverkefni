import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/gradient_card.dart';
import '../widgets/animated_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final leaderboard = gameProvider.players.entries.toList()
      ..sort((a, b) => b.value.wins.compareTo(a.value.wins));
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Leaderboard",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    final playerName = leaderboard[index].key;
                    final player = leaderboard[index].value;

                    return GradientCard(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      title: playerName,
                      subtitle:
                      "Wins: ${player.wins}, Avg. Score: ${player.averageScore.toStringAsFixed(1)}",
                      trailing: Text(
                        "Games Played: ${player.gamesPlayed}",
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedButton(
                    label: "Main Menu",
                    onPressed: () => Navigator.pop(context),
                  ),
                  AnimatedButton(
                    label: "Help",
                    onPressed: () {
                      // Navigate to Help or Onboarding
                      Navigator.pushNamed(context, '/onboarding');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
