import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/gradient_card.dart';
import '../widgets/animated_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

    final leaderboard = playerProvider.players.entries.toList()
      ..sort((a, b) => b.value.wins.compareTo(a.value.wins));

    final mostPlayedGames = gameProvider.getMostPlayedGames();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upplýsingar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {

            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Stigatafla",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: leaderboard.isNotEmpty
                  ? ListView.builder(
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final playerName = leaderboard[index].key;
                  final player = leaderboard[index].value;

                  return GradientCard(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    title: playerName,
                    subtitle:
                    "Sigrar: ${player.wins}, Meðal. Stig: ${player.averageScore.toStringAsFixed(1)}",
                    trailing: Text(
                      "Leikir Spilaðir: ${player.gamesPlayed}",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  "Engum Leikmönnum hefur verið bætt við,Bættu við spilurum til að sjá stigatöflu.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Mest spilaðir leikir",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: mostPlayedGames.isNotEmpty
                  ? ListView.builder(
                itemCount: mostPlayedGames.length,
                itemBuilder: (context, index) {
                  final entry = mostPlayedGames[index];

                  return GradientCard(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    title: entry.key,
                    subtitle: "Hversu oft hefur verið spilað: ${entry.value}",
                  );
                },
              )
                  : const Center(
                child: Text(
                  "Engir Leikir hafa verið spilaðir.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedButton(
                  label: "Aðal Valmynd",
                  onPressed: () => Navigator.pop(context),
                ),
                AnimatedButton(
                  label: "Endursetja",
                  onPressed: () {

                    playerProvider.resetPlayers();
                    gameProvider.resetSelectedGames();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Allar upplýsingar hafa verið endursettar.")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}