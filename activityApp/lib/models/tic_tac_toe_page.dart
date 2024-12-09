import 'package:flutter/material.dart';

class TicTacToePage extends StatefulWidget {
  final VoidCallback onQuit;

  const TicTacToePage({required this.onQuit, super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> board = List.filled(9, "");
  String currentPlayer = "X";
  String winner = "";

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
      winner = "";
    });
  }

  void playMove(int index) {
    if (board[index] == "" && winner == "") {
      setState(() {
        board[index] = currentPlayer;
        if (checkWinner(currentPlayer)) {
          winner = currentPlayer;
        } else if (!board.contains("")) {
          winner = "Draw";
        } else {
          currentPlayer = currentPlayer == "X" ? "O" : "X";
        }
      });
    }
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
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the board size as the smaller of 80% of the width or height
    double boardSize = MediaQuery.of(context).size.shortestSide * 0.8;

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    child: SizedBox(
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
                          return GestureDetector(
                            onTap: () => playMove(index),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
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
          );
        },
      ),
    );
  }
}
