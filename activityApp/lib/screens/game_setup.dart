import 'package:flutter/material.dart';
import 'game_page.dart';
import '../models/games.dart';
import 'dart:math';

class GameSetup extends StatefulWidget {
  @override
  _GameSetupState createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  TextEditingController _nameController = TextEditingController();
  int rounds = 1;
  List<String> players = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Family Game Night")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA0UTfT73CQZwJmfedJSzlS0SJEt8hTT-QPQ&s"),
            ),
            Text('Enter Player Name', style: TextStyle(fontSize: 24)),
            TextField(controller: _nameController, decoration: InputDecoration(hintText: 'Player Name')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addPlayer, child: Text('Add Player')),
            SizedBox(height: 20),
            Text('Choose Number of Rounds', style: TextStyle(fontSize: 18)),
            DropdownButton<int>(
              value: rounds,
              items: List.generate(10, (index) {
                return DropdownMenuItem(child: Text('${index + 1} Rounds'), value: index + 1);
              }).toList(),
              onChanged: (value) {
                setState(() {
                  rounds = value!;
                });
              },
            ),
            if (players.isNotEmpty && rounds > 0)
              ElevatedButton(onPressed: _startGame, child: Text('Start Game')),

            // Display player names on the main menu
            SizedBox(height: 20),
            Text('Players:', style: TextStyle(fontSize: 18)),
            ...players.map((player) => Text(player, style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  void _addPlayer() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        players.add(_nameController.text);
        _nameController.clear();
      });
    }
  }

  void _startGame() {
    if (players.isNotEmpty && rounds > 0) {
      // Select a random game
      final randomGame = Game.getMiniGames()[Random().nextInt(Game.getMiniGames().length)];

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GamePage(
          players: players,
          rounds: rounds,
          initialGame: randomGame,
          onQuit: _quitGame,
        ),
      ));
    }
  }

  void _quitGame() {
    setState(() {
      players.clear(); // Clear players when quitting
    });
  }
}
