import 'package:flutter/material.dart';
import 'games.dart';

class GameSelectionPage extends StatefulWidget {
  final List<Game> availableGames;
  final List<Game> initiallySelectedGames;
  final Function(List<Game>) onSelectionChanged;

  const GameSelectionPage({
    required this.availableGames,
    required this.initiallySelectedGames,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  _GameSelectionPageState createState() => _GameSelectionPageState();
}

class _GameSelectionPageState extends State<GameSelectionPage> {
  late List<Game> _selectedGames;

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

  void _selectAll() {
    setState(() {
      _selectedGames = List.from(widget.availableGames);
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedGames.clear();
    });
  }

  void _saveSelection() {
    widget.onSelectionChanged(_selectedGames);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Games"),
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: _selectAll,
            tooltip: "Select All",
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _deselectAll,
            tooltip: "Deselect All",
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3 / 2,
        ),
        itemCount: widget.availableGames.length,
        itemBuilder: (context, index) {
          final game = widget.availableGames[index];
          final isSelected = _selectedGames.contains(game);

          return GestureDetector(
            onTap: () => _toggleSelection(game),
            child: MouseRegion(
              onEnter: (_) => setState(() {}),
              onExit: (_) => setState(() {}),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? Colors.green : Colors.grey[800],
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                      : [],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        game.imageUrl,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        color: isSelected ? Colors.black.withOpacity(0.4) : null,
                        colorBlendMode: isSelected ? BlendMode.darken : null,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: Colors.black.withOpacity(0.6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              game.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: 0.8,
                              child: Text(
                                game.explanation,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelection,
        tooltip: "Save Selection",
        child: const Icon(Icons.save),
      ),
    );
  }
}
