import 'package:flutter/material.dart';
import 'package:spilakvold/models/suggestion_page.dart';

class HangmanPage extends StatefulWidget {
  const HangmanPage({super.key});

  @override
  State<HangmanPage> createState() => _HangmanPageState();
}

class _HangmanPageState extends State<HangmanPage> {
  late String _wordToGuess;
  final Set<String> _guessedLetters = {};
  int _incorrectGuesses = 0;

  final int _maxGuesses = 6;

  @override
  void initState() {
    super.initState();
    _resetGame(); // Initialize the first game
  }

  void _resetGame({String difficulty = "Easy"}) {
    setState(() {
      final wordPool = difficulty == "Hard"
          ? SuggestionPage.hangmanSuggestions.where((word) => word.length > 7).toList()
          : difficulty == "Medium"
          ? SuggestionPage.hangmanSuggestions.where((word) => word.length > 4 && word.length <= 7).toList()
          : SuggestionPage.hangmanSuggestions.where((word) => word.length <= 4).toList();

      _wordToGuess = (List.from(wordPool)..shuffle()).first.toUpperCase();
      _guessedLetters.clear();
      _incorrectGuesses = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isGameOver = _incorrectGuesses >= _maxGuesses;
    final bool isWinner = _wordToGuess.split('').every((letter) => _guessedLetters.contains(letter));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hangman"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDifficultySelector(),
            const SizedBox(height: 20),
            _buildHangmanDrawing(),
            const SizedBox(height: 20),
            _buildWordDisplay(),
            const SizedBox(height: 20),
            if (isGameOver || isWinner)
              _buildGameOverMessage(isWinner)
            else
              _buildKeyboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _resetGame(difficulty: "Easy"),
          child: const Text("Easy"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _resetGame(difficulty: "Medium"),
          child: const Text("Medium"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _resetGame(difficulty: "Hard"),
          child: const Text("Hard"),
        ),
      ],
    );
  }

  Widget _buildHangmanDrawing() {
    final List<Widget> hangmanParts = [
      const SizedBox(),
      const CircleAvatar(radius: 20, backgroundColor: Colors.black87), // Head
      Container(height: 50, width: 5, color: Colors.black), // Body
      Container(height: 5, width: 30, color: Colors.black), // Left Arm
      Container(height: 5, width: 30, color: Colors.black), // Right Arm
      Container(height: 5, width: 30, color: Colors.black), // Left Leg
      Container(height: 5, width: 30, color: Colors.black), // Right Leg
    ];

    return Column(
      children: [
        Text(
          "Incorrect Guesses: $_incorrectGuesses / $_maxGuesses",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...hangmanParts.take(_incorrectGuesses + 1),
      ],
    );
  }

  Widget _buildWordDisplay() {
    return Center(
      child: Wrap(
        spacing: 8.0,
        children: _wordToGuess.split('').map((letter) {
          final isVisible = _guessedLetters.contains(letter);
          return Text(
            isVisible ? letter : "_",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeyboard() {
    final List<String> alphabet = List.generate(26, (index) => String.fromCharCode(65 + index));
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: alphabet.map((letter) {
        final isUsed = _guessedLetters.contains(letter);
        return ElevatedButton(
          onPressed: isUsed
              ? null
              : () {
            _makeGuess(letter);
          },
          child: Text(letter),
        );
      }).toList(),
    );
  }

  Widget _buildGameOverMessage(bool isWinner) {
    return Column(
      children: [
        Text(
          isWinner ? "🎉 You Win! 🎉" : "💀 You Lose! The word was $_wordToGuess.",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _resetGame,
          child: const Text("Play Again"),
        ),
      ],
    );
  }

  void _makeGuess(String letter) {
    setState(() {
      if (_wordToGuess.contains(letter)) {
        _guessedLetters.add(letter);
      } else {
        _incorrectGuesses++;
      }
    });
  }
}
