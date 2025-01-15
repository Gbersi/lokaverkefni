
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:activityapp/models/games.dart';
import '../Game Functions/mastermind_page.dart';
import '../Game Functions/tic_tac_toe_page.dart';
import '../widgets/animated_button.dart';
import '../widgets/gradient_card.dart';
import 'player_selection_page.dart';
import 'package:activityapp/models/suggestion_page.dart';
import 'package:activityapp/Game Functions/colorhunt_page.dart';
import 'package:activityapp/Game Functions/hangman_page.dart';

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
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
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
        _navigateToTicTacToe();
      } else if (_currentGame!.name == "Mastermind") {
        _navigateToMastermind();
      } else if (_currentGame!.name == "Color Hunt") {
        _navigateToColorHunt();
      } else if (_currentGame!.name == "Hangman") {
        _navigateToHangman();
      }
    });
  }

  void _navigateToHangman() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HangmanPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    ).then((_) => _nextRound());
  }

  void _navigateToTicTacToe() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TicTacToePage(
          mode: 'Tic Tac Toe',
          onQuit: () {
            Navigator.pop(context);
            _nextRound();
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToMastermind() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MastermindPage(
          players: widget.players,
          onQuit: () {
            Navigator.pop(context);
            _nextRound();
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToPlayerSelection() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PlayerSelectionPage(
          players: widget.players,
          message: _currentGame!.name == "Pictionary"
              ? "Choose a player to draw"
              : "Choose a player to act",
          suggestions: _currentGame!.name == "Pictionary"
              ? SuggestionPage.pictionarySuggestions
              : SuggestionPage.charadesSuggestions,
          onDone: () {
            Navigator.pop(context);
            _startTimer();
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToColorHunt() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ColorHuntPage(
          players: widget.players,
          onQuit: () {
            Navigator.pop(context);
            _nextRound();
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
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

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
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
                AnimatedButton(
                  label: "Set Timer",
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _remainingTime = selectedTime;
                      _isTimerRunning = false;
                    });
                  },
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

  void _nextRound() {
    _timer?.cancel();
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
