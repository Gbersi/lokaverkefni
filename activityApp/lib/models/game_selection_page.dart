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
        title: const Text(
          "Select Games",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[200],
        iconTheme: const IconThemeData(color: Colors.black),
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
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[300]!, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Smaller cards with more per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4, // Adjusted for smaller size
          ),
          itemCount: widget.availableGames.length,
          itemBuilder: (context, index) {
            final game = widget.availableGames[index];
            final isSelected = _selectedGames.contains(game);

            return GestureDetector(
              onTap: () {
                _toggleSelection(game);
              },
              child: Transform.scale(
                scale: isSelected ? 0.95 : 1.0, // Shrink effect on selection
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? Colors.greenAccent.withOpacity(0.7)
                            : Colors.black.withOpacity(0.2),
                        blurRadius: isSelected ? 12 : 6,
                        offset: isSelected ? const Offset(0, 4) : const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: isSelected ? Colors.greenAccent : Colors.grey[700]!,
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [Colors.greenAccent.withOpacity(0.3), Colors.greenAccent.withOpacity(0.2)]
                          : [Colors.grey[800]!, Colors.grey[900]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            game.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.greenAccent : Colors.grey[850],
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                game.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                game.explanation,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelection,
        backgroundColor: Colors.greenAccent,
        tooltip: "Save Selection",
        child: const Icon(Icons.save),
      ),
    );
  }
}
