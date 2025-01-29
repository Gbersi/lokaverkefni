
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'package:spilakvold/providers/player_provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

    final selectedGames = gameProvider.selectedGames;
    final players = playerProvider.players.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leikja Skjár'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              gameProvider.resetSelectedGames();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leikjalistinn hefur verið uppfærður.')),
              );
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
              'Selected Games',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: selectedGames.isNotEmpty
                  ? ListView.builder(
                itemCount: selectedGames.length,
                itemBuilder: (context, index) {
                  final game = selectedGames[index];
                  return Card(
                    child: ListTile(
                      title: Text(game.name),
                      subtitle: Text('Erfiðleikastig: ${game.difficulty}'),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'Enginn Leikur Valinn .',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Leikmenn',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: players.isNotEmpty
                  ? ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final playerName = players[index];
                  final player = playerProvider.getPlayer(playerName);
                  return Card(
                    child: ListTile(
                      title: Text(playerName),
                      subtitle: Text(
                        'hversu oft hefur verið spilað: ${player?.gamesPlayed ?? 0}, Sigrar: ${player?.wins ?? 0}',
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'Engum Spilurum hefur verið bætt við .',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}