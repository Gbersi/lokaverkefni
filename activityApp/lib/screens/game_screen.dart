import 'package:flutter/material.dart';
import 'package:activityapp/models/games.dart';

class GameScreen extends StatefulWidget {
  final List<String> players;
  final int rounds;
  final VoidCallback onNextRound;

  const GameScreen({
    required this.players,
    required this.rounds,
    required this.onNextRound,
    super.key,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Game> gameList;
  late Game currentGame;
  late Map<String, int> scores;
  int currentRound = 1;

  @override
  void initState() {
    super.initState();
    gameList = List.from(getGames()); // Clone the list to preserve the original
    currentGame = gameList.isNotEmpty ? gameList.first : _emptyGame();
    scores = {for (var player in widget.players) player: 0};
  }

  Game _emptyGame() {
    return Game(
      name: 'No Games Available',
      explanation: 'Add more games to play!',
      imageUrl: 'https://via.placeholder.com/300',
    );
  }

  void _nextGame() {
    setState(() {
      if (gameList.isNotEmpty) {
        gameList.remove(currentGame);
      }
      if (gameList.isEmpty || currentRound >= widget.rounds) {
        currentGame = _emptyGame(); // Game over
      } else {
        currentGame = gameList.isNotEmpty ? gameList.first : _emptyGame();
        currentRound++;
      }
    });
    widget.onNextRound(); // Notify parent widget (e.g., GamePage) to handle the timer
  }

  void _addPoint(String player) {
    setState(() {
      scores[player] = scores[player]! + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Round $currentRound of ${widget.rounds}',
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentGame.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: currentGame.imageUrl.isNotEmpty
                        ? Image.network(
                      currentGame.imageUrl,
                      fit: BoxFit.cover,
                    )
                        : const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    currentGame.explanation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (gameList.isNotEmpty && currentRound < widget.rounds)
                      ? _nextGame
                      : null,
                  child: const Text('Next Game'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                final player = widget.players[index];
                return ListTile(
                  title: Text(player),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(scores[player].toString()),
                      IconButton(
                        onPressed: () => _addPoint(player),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

