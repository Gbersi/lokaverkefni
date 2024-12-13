import 'package:flutter/material.dart';
import 'package:activityapp/models/game_selection_page.dart';
import 'package:activityapp/screens/game_page.dart';
import 'package:activityapp/models/games.dart';


class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final List<Game> games = getGames();
  late List<Game> _selectedGames;
  final List<String> _players = [];
  int _rounds = 1;

  final TextEditingController _playerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedGames = List.from(games);
  }

  void _addPlayer(String playerName) {
    if (playerName.isNotEmpty && !_players.contains(playerName)) {
      setState(() {
        _players.add(playerName);
        _playerController.clear();
      });
    }
  }

  void _removePlayer(String playerName) {
    setState(() {
      _players.remove(playerName);
    });
  }

  void _navigateToGameSelectionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameSelectionPage(
          availableGames: games,
          initiallySelectedGames: _selectedGames,
          onSelectionChanged: (selectedGames) {
            setState(() {
              _selectedGames = selectedGames;
            });
          },
        ),
      ),
    );
  }

  void _startGame() {
    if (_players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one player to start the game.")),
      );
      return;
    }
    if (_selectedGames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one game to start.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          players: _players,
          rounds: _rounds,
          availableGames: _selectedGames,
          onQuit: _navigateToMainMenu,
        ),
      ),
    );
  }

  void _navigateToMainMenu() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA0UTfT73CQZwJmfedJSzlS0SJEt8hTT-QPQ&s',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Players",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _playerController,
                onSubmitted: _addPlayer,
                decoration: InputDecoration(
                  hintText: "Enter player name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _players.length,
                  itemBuilder: (context, index) {
                    final playerName = _players[index];
                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        title: Text(
                          playerName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removePlayer(playerName),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    "Rounds: ",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  DropdownButton<int>(
                    value: _rounds,
                    dropdownColor: Colors.grey[800],
                    items: List.generate(10, (index) => index + 1)
                        .map((value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _rounds = value ?? 1;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _navigateToGameSelectionPage,
                icon: const Icon(Icons.gamepad),
                label: const Text("Select Games"),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _startGame,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Start Game"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
