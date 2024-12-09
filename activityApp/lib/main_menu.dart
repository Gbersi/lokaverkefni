import 'package:activityapp/screens/game_page.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final List<String> players = [];
  int rounds = 1;
  final playerController = TextEditingController();

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
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => GamePage(
          players: players,
          rounds: rounds,
          onQuit: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
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
            colors: [Colors.blue, Colors.grey],
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA0UTfT73CQZwJmfedJSzlS0SJEt8hTT-QPQ&s%22',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: playerController,
                decoration: InputDecoration(
                  labelText: 'Enter Player Name',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
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
                  child: Text('No players added. Add players to start the game.', style: TextStyle(color: Colors.white)),
                )
                    : ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.lightBlueAccent,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          players[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
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
                  const Text('Rounds:', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: rounds,
                    dropdownColor: Colors.grey[800],
                    items: List.generate(10, (index) => index + 1)
                        .map((value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString(), style: const TextStyle(color: Colors.white)),
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
              Center(
                child: ElevatedButton.icon(
                  onPressed: players.isEmpty ? null : _navigateToGamePage,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
