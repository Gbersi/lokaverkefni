import 'package:flutter/material.dart';
import '../models/games.dart';
import '../widgets/animated_button.dart';
import '../widgets/game_card.dart';


class GameSelectionPage extends StatefulWidget {
  final List<Game> availableGames;
  final List<Game> initiallySelectedGames;
  final Function(List<Game>) onSelectionChanged;
  final int playerCount;

  const GameSelectionPage({
    required this.availableGames,
    required this.initiallySelectedGames,
    required this.onSelectionChanged,
    required this.playerCount,
    super.key,
  });

  @override
  State<GameSelectionPage> createState() => _GameSelectionPageState();
}

class _GameSelectionPageState extends State<GameSelectionPage> {
  late List<Game> _selectedGames;
  bool _filterByPlayerCount = false;

  @override
  void initState() {
    super.initState();
    _selectedGames = List.from(widget.initiallySelectedGames);
  }

  void _toggleSelection(Game game) {
    setState(() {
      if (_selectedGames.contains(game)) {
        _selectedGames.remove(game);
      } else {
        _selectedGames.add(game);
      }
    });
  }

  void _selectAllGames() {
    setState(() {
      _selectedGames = List.from(widget.availableGames);
    });
  }

  void _deselectAllGames() {
    setState(() {
      _selectedGames.clear();
    });
  }

  void _saveSelection() {
    widget.onSelectionChanged(_selectedGames);
    Navigator.pop(context);
  }

  List<Game> _filterGames() {
    if (!_filterByPlayerCount) return widget.availableGames;

    return widget.availableGames.where((game) {
      return game.minPlayers <= widget.playerCount && game.maxPlayers >= widget.playerCount;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredGames = _filterGames();
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select Games"),
          actions: [
            IconButton(
              icon: Icon(_filterByPlayerCount ? Icons.group : Icons.group_off),
              onPressed: () {
                setState(() {
                  _filterByPlayerCount = !_filterByPlayerCount;
                });
              },
              tooltip: "Filter by Player Count",
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: filteredGames.isNotEmpty
              ? GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: filteredGames.length,
            itemBuilder: (context, index) {
              final game = filteredGames[index];
              final isSelected = _selectedGames.contains(game);

              return GameCard(
                title: game.name,
                subtitle: "${game.minPlayers}-${game.maxPlayers} players",
                description: game.explanation,
                imageUrl: game.imageUrl,
                isSelected: isSelected,
                onTap: () => _toggleSelection(game),
              );
            },
          )
              : const Center(
            child: Text(
              "No games match the selected filters.",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedButton(
              label: "Select All",
              onPressed: _selectAllGames,
            ),
            AnimatedButton(
              label: "Deselect All",
              onPressed: _deselectAllGames,
            ),
            AnimatedButton(
              label: "Save Selection",
              onPressed: _saveSelection,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
