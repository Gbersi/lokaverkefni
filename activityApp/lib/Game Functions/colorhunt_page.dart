import 'package:flutter/material.dart';
import 'dart:math';

class ColorHuntPage extends StatefulWidget {
  final List<String> players;
  final VoidCallback onQuit;

  const ColorHuntPage({
    required this.players,
    required this.onQuit,
    super.key,
  });

  @override
  _ColorHuntPageState createState() => _ColorHuntPageState();
}

class _ColorHuntPageState extends State<ColorHuntPage> {
  late String _targetColor;
  bool _winnerDeclared = false;
  String? _winnerName;

  final List<String> _colorNames = [
    "Red",
    "Blue",
    "Green",
    "Yellow",
    "Orange",
    "Purple",
    "Pink",
    "Brown",
    "Black",
    "White"
  ];

  final Map<String, Color> _colorMap = {
    "Red": Colors.red,
    "Blue": Colors.blue,
    "Green": Colors.green,
    "Yellow": Colors.yellow,
    "Orange": Colors.orange,
    "Purple": Colors.purple,
    "Pink": Colors.pink,
    "Brown": Colors.brown,
    "Black": Colors.black,
    "White": Colors.white,
  };

  @override
  void initState() {
    super.initState();
    _generateRandomColor();
  }

  void _generateRandomColor() {
    final randomIndex = Random().nextInt(_colorNames.length);
    setState(() {
      _targetColor = _colorNames[randomIndex];
    });
  }

  void _declareWinner(String playerName) {
    setState(() {
      _winnerDeclared = true;
      _winnerName = playerName;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("We Have a Winner!"),
        content: Text("$playerName found the color first!"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onQuit(); //
            },
            child: const Text("Return to playing"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Color Hunt"),
        actions: [
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Find an object that is:",
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _colorMap[_targetColor],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _targetColor,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            if (!_winnerDeclared)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.players.length,
                  itemBuilder: (context, index) {
                    final playerName = widget.players[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_winnerDeclared) {
                            _declareWinner(playerName);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text(
                          "$playerName: I Found It!",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_winnerDeclared)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Winner: $_winnerName!",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
