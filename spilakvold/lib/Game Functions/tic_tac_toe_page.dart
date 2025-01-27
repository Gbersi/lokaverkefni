import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/confetti_manager.dart';
import 'dart:math';

class TicTacToePage extends StatefulWidget {
  final String mode;
  final VoidCallback onQuit;

  const TicTacToePage({required this.mode, required this.onQuit, super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> board = List.filled(9, "");
  String currentPlayer = "X";
  String winner = "";
  String opponent = "Player"; // Default opponent
  String aiDifficulty = "Easy"; // Default AI difficulty for single-player
  bool showConfetti = false; // For confetti animation
  List<int> winningPattern = []; // Tracks the winning pattern for animation

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
      winner = "";
      showConfetti = false;
      winningPattern = []; // Reset winning pattern
    });
    HapticFeedback.mediumImpact(); // Haptic feedback for reset
  }

  void playMove(int index) {
    if (board[index] == "" && winner == "") {
      setState(() {
        board[index] = currentPlayer;
        HapticFeedback.lightImpact(); // Haptic feedback for cell selection

        if (checkWinner(currentPlayer)) {
          winner = currentPlayer;
          showConfetti = true; // Trigger confetti animation
          HapticFeedback.heavyImpact(); // Haptic feedback for win
        } else if (!board.contains("")) {
          winner = "Draw";
          HapticFeedback.vibrate(); // Haptic feedback for draw
        } else {
          currentPlayer = currentPlayer == "X" ? "O" : "X";

          // If playing against AI, make the AI move
          if (opponent == "AI" && currentPlayer == "O") {
            Future.delayed(const Duration(milliseconds: 500), aiMove);
          }
        }
      });
    }
  }

  void aiMove() {
    int move;
    if (aiDifficulty == "Easy") {
      move = getRandomMove();
    } else if (aiDifficulty == "Medium") {
      move = getBestMove(blockPlayer: true);
    } else {
      move = getBestMove(blockPlayer: false);
    }
    playMove(move);
  }

  int getRandomMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == "") {
        availableMoves.add(i);
      }
    }
    return availableMoves[Random().nextInt(availableMoves.length)];
  }

  int getBestMove({required bool blockPlayer}) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == "") {
        board[i] = currentPlayer;
        if (checkWinner(currentPlayer)) {
          board[i] = "";
          return i;
        }
        board[i] = "";
      }
    }

    if (blockPlayer) {
      String opponentPlayer = currentPlayer == "X" ? "O" : "X";
      for (int i = 0; i < board.length; i++) {
        if (board[i] == "") {
          board[i] = opponentPlayer;
          if (checkWinner(opponentPlayer)) {
            board[i] = "";
            return i;
          }
          board[i] = "";
        }
      }
    }

    return getRandomMove();
  }

  bool checkWinner(String player) {
    const List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        setState(() {
          winningPattern = pattern; // Highlight the winning pattern
        });
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.shortestSide * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: widget.onQuit,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.mode == "Tic Tac Toe")
                    Column(
                      children: [
                        const Text(
                          "Choose Opponent:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          value: opponent,
                          items: ["Player", "AI"].map((opponentType) {
                            return DropdownMenuItem(
                              value: opponentType,
                              child: Text(opponentType),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              opponent = value!;
                            });
                          },
                        ),
                        if (opponent == "AI")
                          DropdownButton<String>(
                            value: aiDifficulty,
                            items: ["Easy", "Medium", "Hard"].map((difficulty) {
                              return DropdownMenuItem(
                                value: difficulty,
                                child: Text("AI Difficulty: $difficulty"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                aiDifficulty = value!;
                              });
                            },
                          ),
                      ],
                    ),
                  if (winner.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        winner == "Draw"
                            ? "It's a Draw!"
                            : "Player $winner Wins!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: Colors.grey.shade700, width: 4),
                      ),
                      width: boardSize,
                      height: boardSize,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: board.length,
                        itemBuilder: (context, index) {
                          final isWinningCell =
                          winningPattern.contains(index); // Check winning cell
                          return GestureDetector(
                            onTap: () => playMove(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: isWinningCell
                                    ? Colors.greenAccent.withOpacity(0.5)
                                    : board[index] != ""
                                    ? (board[index] == "X"
                                    ? Colors.blue[100]
                                    : Colors.red[100])
                                    : Colors.transparent,
                                border: Border.all(color: Colors.grey.shade500),
                              ),
                              child: Center(
                                child: Text(
                                  board[index],
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: board[index] == "X"
                                        ? Colors.blue
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: resetGame,
                    child: const Text("Restart Game"),
                  ),
                ],
              ),
            ),
          ),
          ConfettiManager(
            shouldShow: showConfetti, // Show confetti when triggered
          ),
        ],
      ),
    );
  }
}
