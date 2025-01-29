import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../providers/game_provider.dart';
import '../Game Functions/mastermind_page.dart';
import '../Game Functions/memorycardgame.dart';
import '../Game Functions/tic_tac_toe_page.dart';
import '../providers/player_provider.dart';
import '../widgets/animated_button.dart';
import '../widgets/gradient_card.dart';
import 'player_selection_page.dart';
import '../Game Functions/colorhunt_page.dart';
import '../Game Functions/hangman_page.dart';

class GamePage extends StatefulWidget {
  final List<String> players;
  final int rounds;
  final List<Game> availableGames;
  final VoidCallback onQuit;

  const GamePage({
    required this.players,
    required this.rounds,
    required this.availableGames,
    required this.onQuit,
    super.key,
  });

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  late List<int> _scores;
  int _currentRound = 1;
  Game? _currentGame;
  Timer? _timer;
  int _remainingTime = 60;
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
    if (widget.availableGames.isEmpty) {
      _showNoGamesSelectedDialog();
      return;
    }

    final randomIndex = Random().nextInt(widget.availableGames.length);
    _currentGame = widget.availableGames[randomIndex];
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentGame!.name == "Pictionary" || _currentGame!.name == "Charades") {
        _navigateToPlayerSelection();
      } else if (_currentGame!.name == "Tic Tac Toe") {
        _navigateToGame(TicTacToePage(
          mode: 'Tic Tac Toe',
          onQuit: () {
            Navigator.pop(context);
            _nextRound();
          },
        ));
      } else if (_currentGame!.name == "Mastermind") {
        _navigateToGame(MastermindPage(
          players: widget.players,
          onQuit: () {
            Navigator.pop(context);
            _nextRound();
          },
        ));
      } else if (_currentGame!.name == "Color Hunt") {
        _navigateToGame(ColorHuntPage(
          players: widget.players,
          onQuit: () {
            Navigator.pop(context);
            _nextRound();
          },
        ));
      } else if (_currentGame!.name == "Hangman") {
        _navigateToGame(const HangmanPage());
      } else if (_currentGame!.name == "Memory Card Game") {
        _navigateToGame(const MemoryCardGame(initialLevel: 'Easy'));
      }
    });
  }
  void _nextRound() {
    _timer?.cancel();
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    for (int i = 0; i < widget.players.length; i++) {
      final playerName = widget.players[i];
      final score = _scores[i];
      playerProvider.updatePlayerStats(
        playerName,
        gamesPlayed: 1,
        wins: (score > 0) ? 1 : 0,
      );
    }

    setState(() {
      _isTimerRunning = false;
      _remainingTime = 60;
      if (_currentRound < widget.rounds) {
        _currentRound++;
        _selectRandomGame();
      } else {
        _showGameOverDialog();
      }
    });
  }
  void _navigateToPlayerSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerSelectionPage(
          players: widget.players,
          message: _currentGame!.name == "Pictionary"
              ? "Choose a player to draw"
              : "Choose a player to act",
          suggestions: _currentGame!.name == "Pictionary"
              ? ["Draw a tree", "Draw a house", "Draw a car"]
              : ["Act like a cat", "Act like a teacher", "Act like a pilot"],
          onDone: () {
            Navigator.pop(context);
            _startTimer();
          },
        ),
      ),
    );
  }

  void _navigateToGame(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) => _nextRound());
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

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }


  void _showNoGamesSelectedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Games Selected'),
        content: const Text('Please select at least one game from the main menu.'),
        actions: [
          AnimatedButton(
            label: "OK",
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: const Text('The game has ended.'),
        actions: [
          AnimatedButton(
            label: "Main Menu",
            onPressed: widget.onQuit,
          ),
        ],
      ),
    );
  }

  void _updateScore(int index, int score) {
    setState(() {
      _scores[index] += score;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentGame == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Round $_currentRound / ${widget.rounds}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: _startTimer,
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
                'Game: ${_currentGame!.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _currentGame!.explanation,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _currentGame!.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 200, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Time Remaining: ${_isTimerRunning ? _remainingTime : "Not Started"}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedButton(
                    label: _isTimerRunning ? "Stop Timer" : "Start Timer",
                    onPressed: _isTimerRunning ? _stopTimer : _startTimer,
                  ),
                  AnimatedButton(
                    label: "Next Round",
                    onPressed: _nextRound,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    return GradientCard(
                      title: widget.players[index],
                      subtitle: "Score: ${_scores[index]}",
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
