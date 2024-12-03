import 'package:flutter/material.dart';
import 'dart:math';
import '../models/games.dart';
import 'package:activityapp/screens/game_setup.dart';

class GamePage extends StatefulWidget {
  final List<String> players;
  final int rounds;
  final VoidCallback onQuit;
  final Game initialGame;

  GamePage({required this.players, required this.rounds, required this.onQuit, required this.initialGame});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentRound = 1;
  Map<String, int> scores = {};
  String selectedGame = '';
  String gameExplanation = '';
  String? gameImageUrl;
  bool gameOver = false;

  final List<Game> miniGames = Game.getMiniGames();

  @override
  void initState() {
    super.initState();
    widget.players.forEach((player) {
      scores[player] = 0;
    });

    // Initialize with the initial game
    _setGame(widget.initialGame);
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
            if (!gameOver)
              ...[
                Text(
                  'Current Game: $selectedGame',
                  style: TextStyle(fontSize: 18),
                ),
                if (gameImageUrl != null)
                  Image.network(gameImageUrl!, height: 200),
                SizedBox(height: 20),
                Text(
                  gameExplanation,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
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
              ]
            else
              ...[
                Text(
                  'Game Over!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                _buildWinner(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _restartGame,
                  child: Text('Restart Game'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _quitToMainMenu(context), // Quit to main menu
                  child: Text('Quit'),
                ),
              ],
          ],
        ),
      ),
    );
  }

  void _setGame(Game game) {
    setState(() {
      selectedGame = game.name;
      gameExplanation = game.explanation;
      gameImageUrl = game.imageUrl;
    });
  }

  void _addPointToPlayer(String player) {
    setState(() {
      scores[player] = (scores[player] ?? 0) + 1;
    });
  }

  void _nextRound() {
    setState(() {
      if (currentRound < widget.rounds) {
        currentRound++;
        final nextGame = miniGames[Random().nextInt(miniGames.length)];
        _setGame(nextGame);
      } else {
        gameOver = true;
      }
    });
  }

  Widget _buildWinner() {
    final winner = scores.entries.reduce((a, b) => a.value > b.value ? a : b);
    return Text(
      '${winner.key} wins with ${winner.value} points!',
      style: TextStyle(fontSize: 24, color: Colors.green),
    );
  }

  void _restartGame() {
    setState(() {
      currentRound = 1;
      scores.clear();
      widget.players.forEach((player) {
        scores[player] = 0;
      });
      gameOver = false;
    });

    final nextGame = miniGames[Random().nextInt(miniGames.length)];
    _setGame(nextGame);
  }

  void _quitToMainMenu(BuildContext context) {
    Navigator.of(context).pop(); // Pop the current screen
    widget.onQuit(); // Call the quit callback
  }
}

