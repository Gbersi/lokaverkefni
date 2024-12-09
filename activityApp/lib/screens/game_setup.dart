import 'package:flutter/material.dart';
import 'game_page.dart';

class GameSetup extends StatefulWidget {
  const GameSetup({super.key});

  @override
  _GameSetupState createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  final TextEditingController _playerController = TextEditingController();
  List<String> _players = [];
  int _rounds = 5;

  void _addPlayer() {
    if (_playerController.text.isNotEmpty) {
      setState(() {
        _players.add(_playerController.text.trim());
        _playerController.clear();
      });
    }
  }

  void _removePlayer(String player) {
    setState(() {
      _players.remove(player);
    });
  }

  void _startGame() {
    if (_players.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GamePage(
            players: _players,
            rounds: _rounds,
            onQuit: () {
              setState(() {
                _players.clear();
              });
              Navigator.of(context).pop();
            }, availableGames: [],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one player to start the game!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA0UTfT73CQZwJmfedJSzlS0SJEt8hTT-QPQ&s",
                  height: 150,
                ),
                const SizedBox(height: 20),
                Text(
                  'Family Game Night',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _playerController,
                  decoration: InputDecoration(
                    labelText: 'Enter Player Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _addPlayer(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addPlayer,
                  child: const Text('Add Player'),
                ),
                const SizedBox(height: 20),
                if (_players.isNotEmpty) ...[
                  Text(
                    'Players:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_players[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removePlayer(_players[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Number of Rounds:'),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: _rounds,
                      items: List.generate(
                        10,
                            (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _rounds = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('Start Game'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
