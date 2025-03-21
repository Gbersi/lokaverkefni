import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';

class PlayerDetailsPage extends StatelessWidget {
  final String playerName;

  const PlayerDetailsPage({required this.playerName, super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final gameProvider = Provider.of<GameProvider>(context);
    final player = playerProvider.getPlayer(playerName);

    return Scaffold(
      appBar: AppBar(title: Text("$playerName's Profile")),
      body: player != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: player.avatarUrl != null
                    ? NetworkImage(player.avatarUrl!)
                    : const NetworkImage("https://example.com/default-avatar.png"),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Games Played: ${player.gamesPlayed}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Wins: ${player.wins}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Average Score: ${player.averageScore.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Most Played Games",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildMostPlayedGamesList(gameProvider, playerName),
            ),
          ],
        ),
      )
          : const Center(
        child: Text(
          "Player not found!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMostPlayedGamesList(GameProvider gameProvider, String playerName) {
    final mostPlayedGames = gameProvider.selectedGames;

    if (mostPlayedGames.isEmpty) {
      return const Center(
        child: Text(
          "No games played yet.",
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      itemCount: mostPlayedGames.length,
      itemBuilder: (context, index) {
        final game = mostPlayedGames[index];
        return Card(
          child: ListTile(
            title: Text(game.name),
            subtitle: Text("Difficulty: ${game.difficulty}"),
          ),
        );
      },
    );
  }
}
