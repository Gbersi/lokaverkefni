import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:activityapp/models/games.dart';

class GamePage extends StatefulWidget {
  final List<String> players;
  final int rounds;
  final VoidCallback onQuit;

  const GamePage({
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
  int _remainingTime = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _scores = List.filled(widget.players.length, 0);
    _selectRandomGame();
  }

  // Dispose method to cancel the timer when leaving the screen
  @override
  void dispose() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    super.dispose();
  }

  void _selectRandomGame() {
    final games = getGames();
    final randomIndex = Random().nextInt(games.length);
    _currentGame = games[randomIndex];
  }

  void _updateScore(int index, int score) {
    setState(() {
      _scores[index] += score;
    });
  }

  void _nextRound() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    setState(() {
      _remainingTime = 0;
      _isTimerRunning = false;
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
      _remainingTime = 0;
      _isTimerRunning = false;
      if (_timer?.isActive ?? false) {
        _timer?.cancel();
      }
    });
  }

  void _quitGame() {
    widget.onQuit();
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Winner: ${_getWinner()}'),
            const SizedBox(height: 20),
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA0UTfT73CQZwJmfedJSzlS0SJEt8hTT-QPQ&s",
              height: 200,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: _restartGame,
            child: const Text('Restart Game'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _quitGame();
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }

  String _getWinner() {
    int maxScore = _scores.reduce((a, b) => a > b ? a : b);
    int winnerIndex = _scores.indexOf(maxScore);
    return widget.players[winnerIndex];
  }

  // Method to show the timer setup dialog
  void _showTimerDialog() {
    int selectedTime = 30;
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
                    label: selectedTime.toString(),
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
                    setState(() {
                      _remainingTime = selectedTime;
                      _isTimerRunning = true;
                    });
                    Navigator.of(context).pop();
                    _startTimer();
                  },
                  child: const Text("Start Timer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to start the timer
  void _startTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
        _showTimeUpDialog();
      } else {
        setState(() {
          _remainingTime--; // Decrease remaining time by 1 each second
        });
      }
    });
  }

  // Method to show time up dialog
  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Time's Up!"),
        content: const Text("The timer has ended."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _quitGame,
          ),
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: _showTimerDialog, // Show timer setup dialog when tapped
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Round $_currentRound / ${widget.rounds}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Game: ${_currentGame.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'Explanation: ${_currentGame.explanation}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Image.network(
                _currentGame.imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 200,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // Display the remaining time if any
              if (_isTimerRunning && _remainingTime > 0)
                Text(
                  'Remaining Time: $_remainingTime seconds',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(widget.players[index]),
                        subtitle: Text('Score: ${_scores[index]}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _updateScore(index, 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _updateScore(index, -1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextRound,
                child: const Text('Next Round'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

