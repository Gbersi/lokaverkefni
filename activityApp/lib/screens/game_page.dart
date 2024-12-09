import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:activityapp/models/games.dart';
import 'player_selection_page.dart';
import 'package:activityapp/models/suggestion_page.dart';

class GamePage extends StatefulWidget {
  final List<String> players;
  final int rounds;
  final VoidCallback onQuit;

  const GamePage({super.key,
    required this.players,
    required this.rounds,
    required this.onQuit,
  });

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<int> _scores;
  int _currentRound = 1;
  late Game _currentGame;
  Timer? _timer;
  int _remainingTime = 30;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _scores = List.filled(widget.players.length, 0);
    _selectRandomGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectRandomGame() {
    final games = getGames();
    final randomIndex = Random().nextInt(games.length);
    _currentGame = games[randomIndex];

    if (_currentGame.name == "Pictionary" || _currentGame.name == "Charades") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerSelectionPage(
            players: widget.players,
            message: _currentGame.name == "Pictionary"
                ? "Choose a player to draw"
                : "Choose a player to act",
            suggestions: _currentGame.name == "Pictionary"
                ? SuggestionPage.pictionarySuggestions
                : SuggestionPage.charadesSuggestions,
            onDone: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  void _nextRound() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingTime = 30;
      if (_currentRound < widget.rounds) {
        _currentRound++;
        _selectRandomGame();
      } else {
        _showGameOverDialog();
      }
    });
  }

  void _restartGame() {
    Navigator.of(context).pop();
    setState(() {
      _scores = List.filled(widget.players.length, 0);
      _currentRound = 1;
      _selectRandomGame();
      _remainingTime = 30;
      _isTimerRunning = false;
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over!'),
        content: const Text('The game has ended.'),
        actions: [
          ElevatedButton(
            onPressed: _restartGame,
            child: const Text('Restart Game'),
          ),
          ElevatedButton(
            onPressed: widget.onQuit,
            child: const Text('Main Menu'),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
        _nextRound();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  void _adjustTimer() {
    int selectedTime = _remainingTime;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Set Timer"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Select Time: $selectedTime seconds"),
                  Slider(
                    value: selectedTime.toDouble(),
                    min: 30,
                    max: 120,
                    divisions: 90,
                    label: "$selectedTime seconds",
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _remainingTime = selectedTime;
                      _isTimerRunning = false;
                    });
                  },
                  child: const Text('Set Timer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateScore(int index, int score) {
    setState(() {
      _scores[index] += score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round $_currentRound / ${widget.rounds}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: _adjustTimer,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: widget.onQuit,
          ),
        ],
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
            children: [
              Text(
                'Game: ${_currentGame.name}',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _currentGame.explanation,
                style: const TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _currentGame.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Time Remaining: ${_isTimerRunning ? _remainingTime : "Not Started"}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isTimerRunning ? null : _startTimer,
                icon: const Icon(Icons.timer),
                label: const Text('Start Timer'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _nextRound,
                icon: const Icon(Icons.skip_next),
                label: const Text('Next Round'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[800],
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          widget.players[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _scores[index].toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () => _updateScore(index, 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => _updateScore(index, -1),
                            ),
                          ],
                        ),
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
