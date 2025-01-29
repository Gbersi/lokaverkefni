import 'package:flutter/material.dart';

class MemoryCardGame extends StatefulWidget {
  final String initialLevel;
  final Function(int score)? onScoreUpdate;

  const MemoryCardGame({super.key, required this.initialLevel, this.onScoreUpdate});

  @override
  _MemoryCardGameState createState() => _MemoryCardGameState();
}

class _MemoryCardGameState extends State<MemoryCardGame> {
  late String _level;
  late List<String> _data;
  late List<bool> _cardFlipped;
  late List<bool> _cardMatched;
  int _previousIndex = -1;
  int _matchesLeft = 0;
  int _score = 0;
  bool _wait = false;

  @override
  void initState() {
    super.initState();
    _level = widget.initialLevel;
    _initializeGame();
  }

  void _initializeGame() {
    _data = _getSourceArray(_level);
    _cardFlipped = List<bool>.filled(_data.length, false);
    _cardMatched = List<bool>.filled(_data.length, false);
    _matchesLeft = _data.length ~/ 2;
    _score = 0;
    _previousIndex = -1;
    _wait = false;
  }

  List<String> _getSourceArray(String level) {
    final sourceArray = [
      "lib/assets/animalspics/dino.png",
      "lib/assets/animalspics/fish.png",
      "lib/assets/animalspics/frog.png",
      "lib/assets/animalspics/girraf.png",
      "lib/assets/animalspics/peacock.png",
      "lib/assets/animalspics/quest.png",
      "lib/assets/animalspics/rabbit.png",
      "lib/assets/animalspics/seahorse.png",
      "lib/assets/animalspics/shark.png",
      "lib/assets/animalspics/whale.png",
      "lib/assets/animalspics/wolf.png",
      "lib/assets/animalspics/zoo.png",
    ];

    late int count;
    if (level == "Easy") {
      count = 6;
    } else if (level == "Medium") {
      count = 12;
    } else {
      count = 18;
    }

    final selectedArray = sourceArray.sublist(0, count ~/ 2);
    final fullArray = [...selectedArray, ...selectedArray];
    fullArray.shuffle();
    return fullArray;
  }

  void _onCardTap(int index) {
    if (_wait || _cardFlipped[index] || _cardMatched[index]) return;

    setState(() {
      _cardFlipped[index] = true;
    });

    if (_previousIndex == -1) {
      _previousIndex = index;
    } else {
      _wait = true;
      if (_data[_previousIndex] == _data[index]) {
        // Cards match
        setState(() {
          _cardMatched[_previousIndex] = true;
          _cardMatched[index] = true;
          _matchesLeft--;
          _score += 10;
          _previousIndex = -1;
          _wait = false;

          if (_matchesLeft == 0) {
            _endGame();
          }
        });
      } else {
        // Cards don’t match
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _cardFlipped[_previousIndex] = false;
            _cardFlipped[index] = false;
            _previousIndex = -1;
            _wait = false;
          });
        });
      }
    }
  }

  void _endGame() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Til Hamingju!"),
        content: Text("þú paraðir saman öll spjöldin! Stigin þín eru $_score."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame(_level);
            },
            child: const Text("Spila aftur"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Hætta"),
          ),
        ],
      ),
    );
  }

  void _restartGame(String level) {
    setState(() {
      _level = level;
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minnis samstæðu leikur - $_level'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _restartGame(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "Easy",
                child: Text("Easy"),
              ),
              const PopupMenuItem(
                value: "Medium",
                child: Text("Medium"),
              ),
              const PopupMenuItem(
                value: "Hard",
                child: Text("Hard"),
              ),
            ],
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _data.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _onCardTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _cardFlipped[index] || _cardMatched[index] ? Colors.white : Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
              border: _cardMatched[index]
                  ? Border.all(color: Colors.green, width: 4.0)
                  : null,
              image: _cardFlipped[index] || _cardMatched[index]
                  ? DecorationImage(
                image: AssetImage(_data[index]),
                fit: BoxFit.contain,
              )
                  : null,
            ),
            child: !_cardFlipped[index] && !_cardMatched[index]
                ? const Icon(Icons.question_mark, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}
