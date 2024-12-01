import 'package:flutter/material.dart';
import 'game_page.dart';

class GameSetup extends StatefulWidget {
  @override
  _GameSetupState createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  TextEditingController _nameController = TextEditingController();
  int rounds = 1;
  List<String> players = [];
  bool gameStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Family Game Night")),
      body: gameStarted
          ? GamePage(players: players, rounds: rounds)
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
      setState(() {
        gameStarted = true;
      });
    }
  }
}
