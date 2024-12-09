import 'package:flutter/material.dart';
import 'games.dart';


class GameSelectionPage extends StatefulWidget {
  final List<Game> availableGames;

  const GameSelectionPage({required this.availableGames, super.key});

  @override
  State<GameSelectionPage> createState() => _GameSelectionPageState();
}

class _GameSelectionPageState extends State<GameSelectionPage> {
  late List<Game> selectedGames;

  @override
  void initState() {
    super.initState();
    selectedGames = List.from(widget.availableGames);
  }

  @override
  Widget build(BuildContext context) {
    final allGames = getGames();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Games'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: allGames.length,
                  itemBuilder: (context, index) {
                    final game = allGames[index];
                    final isSelected = selectedGames.contains(game);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedGames.remove(game);
                          } else {
                            selectedGames.add(game);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? Colors.green : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            game.name,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(game.explanation),
                          trailing: Icon(
                            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isSelected ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, selectedGames);
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Selection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
