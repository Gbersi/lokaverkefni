import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/games.dart';
import 'dart:math';


class GamePage extends StatefulWidget {
  final List<String> players;
  final int rounds;

  GamePage({required this.players, required this.rounds});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentRound = 1;
  Map<String, int> scores = {};
  String selectedGame = '';
  String gameExplanation = '';
  String? errorMessage;
  String? gameImage;

  final List<Game> miniGames = Game.getMiniGames();

  @override
  void initState() {
    super.initState();
    widget.players.forEach((player) {
      scores[player] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round $currentRound / ${widget.rounds}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Game: $selectedGame',
              style: TextStyle(fontSize: 18),
            ),
            if (gameImage != null)
              Image.asset(gameImage!, height: 200),
            SizedBox(height: 20),
            Text(gameExplanation, style: TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _playGame, child: Text('Start $selectedGame')),
            if (errorMessage != null)
              Text(errorMessage!, style: TextStyle(color: Colors.red, fontSize: 16)),
            SizedBox(height: 20),
            ...widget.players.map((player) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$player\'s Score: ${scores[player]}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _addPointToPlayer(player),
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextRound,
              child: Text('Next Round'),
            ),
          ],
        ),
      ),
    );
  }

  void _playGame() {
    final selected = miniGames[Random().nextInt(miniGames.length)]; // Random selection
    setState(() {
      selectedGame = selected.name;
      gameExplanation = selected.explanation;
      gameImage = selected.image;
    });
  }

  void _addPointToPlayer(String player) {
    setState(() {
      scores[player] = (scores[player] ?? 0) + 1;
    });
  }

  void _nextRound() {
    bool isValid = true;
    errorMessage = null;
    widget.players.forEach((player) {
      if (scores[player] == null || scores[player]! < 0) {
        isValid = false;
        errorMessage = 'Please enter valid scores for all players';
      }
    });

    if (isValid) {
      setState(() {
        if (currentRound < widget.rounds) {
          currentRound++;
          _playGame();
        } else {
          errorMessage = 'Game Over! Thank you for playing.';
        }
      });
    } else {
      setState(() {});
    }
  }
}
