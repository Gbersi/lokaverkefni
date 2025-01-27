import 'package:flutter/material.dart';
import '../providers/game_provider.dart';
import 'package:provider/provider.dart';
class PlayerDetailsPage extends StatelessWidget {
  final String playerName;

  const PlayerDetailsPage({required this.playerName, super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<GameProvider>(context).getPlayer(playerName);

    return Scaffold(
      appBar: AppBar(title: Text("$playerName's Profile")),
      body: player != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: player.avatarUrl != null
                  ? NetworkImage(player.avatarUrl!)
                  : const NetworkImage("https://example.com/default-avatar.png"),
            ),
            const SizedBox(height: 20),
            Text("Leikir spilaðir: ${player.gamesPlayed}", style: const TextStyle(fontSize: 18)),
            Text("Sigrar: ${player.wins}", style: const TextStyle(fontSize: 18)),
            Text(
              "Meðal Stiga fjöldi : ${player.averageScore.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      )
          : const Center(child: Text("Fann ekki Leikmann !")),
    );
  }
}
