import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/confetti_manager.dart';
import 'package:activityapp/models/suggestion_page.dart' as SuggestionModel;

enum PictionaryStep { selectDrawer, suggestionSelection, drawing }

class PictionaryFlowPage extends StatefulWidget {
  final List<String> players;
  final VoidCallback onQuit;

  const PictionaryFlowPage({super.key, required this.players, required this.onQuit});

  @override
  PictionaryFlowPageState createState() => PictionaryFlowPageState();
}

class PictionaryFlowPageState extends State<PictionaryFlowPage> {
  PictionaryStep _currentStep = PictionaryStep.selectDrawer;
  String? _drawerName;
  String? _chosenPrompt;
  final List<Offset?> _points = []; // Marked as final
  final TextEditingController _guessController = TextEditingController();
  final List<String> _guesses = [];
  bool _showConfetti = false;

  // Timer variables
  int _timerDuration = 60; // default duration in seconds
  int _timeLeft = 60;
  Timer? _countdownTimer;
  bool _isTimerRunning = false;

  // Suggestions for drawing
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _timeLeft = _timerDuration;
  }

  @override
  void dispose() {
    _guessController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // Timer functions
  void _startTimer() {
    if (_isTimerRunning) return;
    setState(() {
      _isTimerRunning = true;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _timeLeft = _timerDuration;
    });
  }

  void _setTimerDuration(int seconds) {
    _stopTimer();
    setState(() {
      _timerDuration = seconds;
      _timeLeft = seconds;
    });
  }

  // Flow functions

  // Step 1: Select the drawer
  void _selectDrawer(String player) {
    setState(() {
      _drawerName = player;
      _currentStep = PictionaryStep.suggestionSelection;
      _suggestions = (List<String>.from(SuggestionModel.SuggestionPage.pictionarySuggestions)
        ..shuffle())
          .take(5)
          .toList();
    });
  }

  // Step 2: The drawer picks one suggestion
  void _selectSuggestion(String suggestion) {
    setState(() {
      _chosenPrompt = suggestion;
      _currentStep = PictionaryStep.drawing;
    });
  }

  // Step 3: During drawing, guesses are submitted.
  void _addGuess() {
    final guess = _guessController.text.trim();
    if (guess.isNotEmpty) {
      setState(() {
        _guesses.add(guess);
        if (_chosenPrompt != null &&
            guess.toLowerCase() == _chosenPrompt!.toLowerCase()) {
          _showConfetti = true;
          HapticFeedback.heavyImpact();
          Future.delayed(const Duration(milliseconds: 300), _showWinDialog);
        } else {
          HapticFeedback.lightImpact();
        }
      });
      _guessController.clear();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Correct!"),
        content: Text("$_drawerName guessed the word correctly!"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onQuit();
            },
            child: const Text("Return to Menu"),
          ),
        ],
      ),
    );
  }

  void _clearCanvas() {
    setState(() {
      _points.clear();
    });
    HapticFeedback.mediumImpact();
  }

  // UI for step 1: Selecting the drawer
  Widget _buildSelectDrawerStep() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pictionary: Select Drawer"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Please choose a player to draw",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                final player = widget.players[index];
                return ListTile(
                  title: Text(player),
                  onTap: () => _selectDrawer(player),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // UI for step 2: Suggestion selection (only visible to the drawer)
  Widget _buildSuggestionSelectionStep() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pictionary: Suggestion Selection"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Pass the phone to $_drawerName.\nWhen ready, choose one drawing suggestion:",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(suggestion),
                    onTap: () => _selectSuggestion(suggestion),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // UI for step 3: The drawing and guessing phase.
  // The chosen prompt is hidden so that other players cannot see it.
  Widget _buildDrawingStep() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pictionary: Drawing Phase"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: widget.onQuit,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Timer controls
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Time Left: $_timeLeft s", style: const TextStyle(fontSize: 18)),
                    ElevatedButton(
                      onPressed: _isTimerRunning ? _stopTimer : _startTimer,
                      child: Text(_isTimerRunning ? "Stop" : "Start"),
                    ),
                    ElevatedButton(
                      onPressed: _resetTimer,
                      child: const Text("Reset"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController(text: _timerDuration.toString());
                            return AlertDialog(
                              title: const Text("Set Timer Duration (seconds)"),
                              content: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    int? newTime = int.tryParse(controller.text);
                                    if (newTime != null && newTime > 0) {
                                      _setTimerDuration(newTime);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Set"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("Set Time"),
                    ),
                  ],
                ),
              ),
              // Drawing canvas
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        final renderBox = context.findRenderObject() as RenderBox;
                        _points.add(renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanEnd: (_) {
                      _points.add(null);
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(points: _points),
                      child: Container(),
                    ),
                  ),
                ),
              ),
              // Guessing interface
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _guessController,
                            decoration: const InputDecoration(
                              labelText: "Enter your guess",
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _addGuess(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _addGuess,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: _guesses.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(_guesses[index]),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _clearCanvas,
                      child: const Text("Clear Canvas"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Confetti animation on win
          if (_showConfetti)
            ConfettiManager(
              shouldShow: _showConfetti,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case PictionaryStep.selectDrawer:
        return _buildSelectDrawerStep();
      case PictionaryStep.suggestionSelection:
        return _buildSuggestionSelectionStep();
      case PictionaryStep.drawing:
        return _buildDrawingStep();
    }
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      final point = points[i];
      final nextPoint = points[i + 1];
      if (point != null && nextPoint != null) {
        canvas.drawLine(point, nextPoint, paint);
      } else if (point != null && nextPoint == null) {
        canvas.drawPoints(PointMode.points, [point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
