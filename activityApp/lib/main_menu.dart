import 'package:flutter/material.dart';
import 'package:activityapp/screens/game_page.dart';
import 'package:activityapp/models/game_selection_page.dart';
import 'package:activityapp/models/games.dart';


class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final List<String> players = [];
  int rounds = 1;
  final playerController = TextEditingController();
  List<Game> availableGames = getGames();

  void _addPlayer(String name) {
    if (name.isNotEmpty) {
      setState(() {
        players.add(name);
      });
      playerController.clear();
    }
  }

  void _removePlayer(int index) {
    setState(() {
      players.removeAt(index);
    });
  }

  void _navigateToGamePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          players: players,
          rounds: rounds,
          availableGames: availableGames,
          onQuit: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
    );
  }

  void _navigateToGameSelectionPage() async {
    final selectedGames = await Navigator.push<List<Game>>(
      context,
      MaterialPageRoute(
        builder: (context) => GameSelectionPage(
          availableGames: availableGames,
        ),
      ),
    );

    if (selectedGames != null) {
      setState(() {
        availableGames = selectedGames;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Game'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA0UTfT73CQZwJmfedJSzlS0SJEt8hTT-QPQ&s%22',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: playerController,
                decoration: InputDecoration(
                  labelText: 'Enter Player Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSubmitted: (value) => _addPlayer(value),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _addPlayer(playerController.text),
                icon: const Icon(Icons.add),
                label: const Text('Add Player'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Players:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Expanded(
                child: players.isEmpty
                    ? const Center(
                  child: Text(
                    'No players added. Add players to start the game.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 3,
                      child: ListTile(
                        title: Text(players[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removePlayer(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Rounds:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: rounds,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    items: List.generate(10, (index) => index + 1)
                        .map((value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        rounds = value ?? 1;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: players.isEmpty ? null : _navigateToGamePage,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Game'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _navigateToGameSelectionPage,
                icon: const Icon(Icons.games),
                label: const Text('Select Games'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
