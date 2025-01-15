
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Screen'),
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
              child: gameProvider.selectedGames.isNotEmpty
                  ? ListView.builder(
                itemCount: gameProvider.selectedGames.length,
                itemBuilder: (context, index) {
                  final gameName = gameProvider.selectedGames[index];
                  return Card(
                    child: ListTile(
                      title: Text(gameName as String),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No games selected.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Players',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: gameProvider.players.isNotEmpty
                  ? ListView.builder(
                itemCount: gameProvider.players.length,
                itemBuilder: (context, index) {
                  final playerName = gameProvider.players.keys.elementAt(index);
                  return Card(
                    child: ListTile(
                      title: Text(playerName),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No players added.',
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
