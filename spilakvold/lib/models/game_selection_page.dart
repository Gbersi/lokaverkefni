
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../services/theme_animations_updates.dart';
import '../services/theme_notifier.dart';
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
  final ScrollController _scrollController = ScrollController();

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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final BoxDecoration backgroundGradient = themeNotifier.isDarkTheme
        ? AppThemes.darkBackgroundGradient
        : themeNotifier.isCustomTheme
        ? AppThemes.customBackgroundGradient
        : AppThemes.lightBackgroundGradient;

    final filteredGames = _filterGames();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Veldu Leiki"),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(
              _filterByPlayerCount ? Icons.filter_alt : Icons.filter_alt_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _filterByPlayerCount = !_filterByPlayerCount;
              });
            },
            tooltip: "Filtera eftir fjölda leikmanna",
          ),
        ],
      ),
      body: Container(
        decoration: backgroundGradient,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Veldu leiki til að spila",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 8,
                radius: const Radius.circular(10),
                interactive: true,
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: filteredGames.length,
                  itemBuilder: (context, index) {
                    final game = filteredGames[index];
                    final isSelected = _selectedGames.contains(game);

                    return GameCard(
                      title: game.name,
                      subtitle: "${game.minPlayers}-${game.maxPlayers} spilarar",
                      description: game.explanation,
                      imageUrl: game.imageUrl,
                      isSelected: isSelected,
                      onTap: () => _toggleSelection(game),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            onPressed: _selectAllGames,
            backgroundColor: Colors.teal,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text("Velja Allt"),
          ),
          FloatingActionButton.extended(
            onPressed: _deselectAllGames,
            backgroundColor: Colors.redAccent,
            icon: const Icon(Icons.cancel, color: Colors.white),
            label: const Text("Afvelja Allt"),
          ),
          FloatingActionButton.extended(
            onPressed: _saveSelection,
            backgroundColor: Colors.blueAccent,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text("Vista"),
          ),
        ],
      ),
    );
  }
}
