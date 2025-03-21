import 'package:flutter/material.dart';

class PlayerSelectionPage extends StatelessWidget {
  final List<String> players;
  final String message;
  final List<String> suggestions;
  final VoidCallback onDone;

  const PlayerSelectionPage({
    required this.players,
    required this.message,
    required this.suggestions,
    required this.onDone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Player'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[800],
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          players[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerSuggestionPage(
                                playerName: players[index],
                                suggestions: suggestions,
                                onDone: () {
                                  Navigator.pop(context);
                                  onDone();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerSuggestionPage extends StatelessWidget {
  final String playerName;
  final List<String> suggestions;
  final VoidCallback onDone;

  const PlayerSuggestionPage({
    required this.playerName,
    required this.suggestions,
    required this.onDone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$playerName\'s Suggestions'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[800],
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(
                  suggestions[index],
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(Icons.check, color: Colors.green),
                onTap: onDone,
              ),
            );
          },
        ),
      ),
    );
  }
}
