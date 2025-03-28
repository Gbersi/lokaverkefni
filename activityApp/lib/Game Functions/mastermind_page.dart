import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../services/confetti_manager.dart';

class MastermindPage extends StatefulWidget {
  final List<String> players;
  final VoidCallback onQuit;

  const MastermindPage({
    required this.players,
    required this.onQuit,
    super.key,
  });

  @override
  _MastermindPageState createState() => _MastermindPageState();
}

class _MastermindPageState extends State<MastermindPage> {
  final List<String> _colors = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple"];
  late List<String> _secretCode;
  final List<List<String>> _guesses = [];
  final List<Map<String, int>> _feedback = [];
  List<String> _currentGuess = [];
  int _maxGuesses = 10;
  int _remainingHints = 2;
  int _currentPlayerIndex = 0;
  bool _hasWon = false;

  @override
  void initState() {
    super.initState();
    _generateSecretCode();
  }

  void _generateSecretCode() {
    final random = Random();
    _secretCode = List.generate(4, (_) => _colors[random.nextInt(_colors.length)]);

  }

  void _changeDifficulty(String difficulty) {
    setState(() {
      switch (difficulty) {
        case 'Easy':
          _maxGuesses = 30;
          _remainingHints = 3;
          break;
        case 'Medium':
          _maxGuesses = 10;
          _remainingHints = 2;
          break;
        case 'Hard':
          _maxGuesses = 5;
          _remainingHints = 1;
          break;
      }
    });
  }

  void _submitGuess() {
    if (_currentGuess.length != 4) {
      HapticFeedback.vibrate();
      return;
    }

    _checkGuess(_currentGuess);
    setState(() {
      _currentGuess = [];
    });

    if (_guesses.length >= _maxGuesses) {
      _showLoseDialog();
    }
  }

  void _checkGuess(List<String> guess) {
    int correctPositions = 0;
    int correctColors = 0;

    List<String> secretCodeCopy = List.from(_secretCode);
    List<String> guessCopy = List.from(guess);

    for (int i = 0; i < guessCopy.length; i++) {
      if (guessCopy[i] == secretCodeCopy[i]) {
        correctPositions++;
        guessCopy[i] = "";
        secretCodeCopy[i] = "";
      }
    }

    for (int i = 0; i < guessCopy.length; i++) {
      if (guessCopy[i].isNotEmpty && secretCodeCopy.contains(guessCopy[i])) {
        correctColors++;
        secretCodeCopy[secretCodeCopy.indexOf(guessCopy[i])] = "";
      }
    }

    setState(() {
      _guesses.add(guess);
      _feedback.add({
        "correctPositions": correctPositions,
        "correctColors": correctColors,
      });
    });

    if (correctPositions == 4) {
      setState(() {
        _hasWon = true;
      });
      HapticFeedback.heavyImpact();
      _showWinDialog();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  void _useHint() {
    if (_remainingHints > 0) {
      final randomIndex = Random().nextInt(_secretCode.length);
      final hintColor = _secretCode[randomIndex];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hint: One of the colors is $hintColor")),
      );

      setState(() {
        _remainingHints--;
      });

      HapticFeedback.selectionClick();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hints remaining!")),
      );
      HapticFeedback.vibrate();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Congratulations!"),
        content: Text(
            "${widget.players[_currentPlayerIndex]} guessed the code in ${_guesses.length} turns!"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _proceedToNextPlayer();
            },
            child: const Text("Next Player"),
          ),
        ],
      ),
    );
  }

  void _showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("${widget.players[_currentPlayerIndex]} ran out of guesses!"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _proceedToNextPlayer();
            },
            child: const Text("Next Player"),
          ),
        ],
      ),
    );
    HapticFeedback.vibrate(); // Vibrate on losing
  }

  void _proceedToNextPlayer() {
    setState(() {
      _currentPlayerIndex++;
      _guesses.clear();
      _feedback.clear();
      _currentGuess.clear();
      _hasWon = false;
      if (_currentPlayerIndex >= widget.players.length) {
        _currentPlayerIndex = 0;
      }
      _generateSecretCode();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Next up: ${widget.players[_currentPlayerIndex]}"),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mastermind - ${widget.players[_currentPlayerIndex]}'s Turn"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeDifficulty,
            itemBuilder: (context) => [
              const PopupMenuItem(value: "Easy", child: Text("Easy")),
              const PopupMenuItem(value: "Medium", child: Text("Medium")),
              const PopupMenuItem(value: "Hard", child: Text("Hard")),
            ],
            child: const Icon(Icons.settings),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: widget.onQuit,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Guesses Remaining: ${_maxGuesses - _guesses.length}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Hints Remaining: $_remainingHints",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _guesses.length,
                    itemBuilder: (context, index) {
                      final guess = _guesses[index];
                      final feedback = _feedback[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: guess
                                .map((color) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                border: feedback['correctPositions']! > 0
                                    ? Border.all(
                                  color: Colors.greenAccent,
                                  width: 3,
                                )
                                    : null,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: _getColor(color),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ))
                                .toList(),
                          ),
                          title: Text(
                            "Positions: ${feedback['correctPositions']} | Colors: ${feedback['correctColors']}",
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _colors
                      .map((color) => ElevatedButton(
                    onPressed: _currentGuess.length < 4
                        ? () {
                      setState(() {
                        _currentGuess.add(color);
                      });
                      HapticFeedback.selectionClick(); // Feedback for button press
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getColor(color),
                      shape: const CircleBorder(),
                      fixedSize: const Size(50, 50),
                    ),
                    child: const SizedBox(),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                if (_currentGuess.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    children: _currentGuess.map((color) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: _getColor(color),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _remainingHints > 0 ? _useHint : null,
                  icon: const Icon(Icons.lightbulb),
                  label: const Text("Use Hint"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _currentGuess.length == 4 ? _submitGuess : null,
                  child: const Text("Submit Guess"),
                ),
              ],
            ),
          ),
          ConfettiManager(
            shouldShow: _hasWon,
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case "Red":
        return Colors.red;
      case "Blue":
        return Colors.blue;
      case "Green":
        return Colors.green;
      case "Yellow":
        return Colors.yellow;
      case "Orange":
        return Colors.orange;
      case "Purple":
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}

