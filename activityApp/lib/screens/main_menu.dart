import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../providers/game_provider.dart';
import '../services/theme_animations_updates.dart';
import '../services/theme_notifier.dart';
import 'dashboard_page.dart';
import 'game_page.dart';
import 'onboarding_page.dart';
import '../models/game_selection_page.dart';
import '../widgets/animated_button.dart';
import '../widgets/gradient_card.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  List<String> players = [];
  List<Game> availableGames = [];
  List<Game> _selectedGames = [];
  final TextEditingController _playerController = TextEditingController();
  int _rounds = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

      setState(() {
        availableGames = gameProvider.getGames();
        _selectedGames = List.from(availableGames);
        players = playerProvider.players.keys.toList();
      });
    });
  }

  void _addPlayer(String playerName) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    if (playerName.isNotEmpty && !playerProvider.players.containsKey(playerName)) {
      playerProvider.addPlayer(playerName, 'https://example.com/default-avatar.png');
      setState(() {
        players = playerProvider.players.keys.toList();
        _playerController.clear();
      });
    }
  }

  void _removePlayer(String playerName) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    playerProvider.removePlayer(playerName);
    setState(() {
      players = playerProvider.players.keys.toList();
    });
  }

  void _navigateToGameSelectionPage() async {
    final selectedGames = await Navigator.push<List<Game>>(
      context,
      MaterialPageRoute(
        builder: (context) => GameSelectionPage(
          availableGames: availableGames,
          initiallySelectedGames: _selectedGames,
          onSelectionChanged: (games) {
            setState(() {
              _selectedGames = games;
            });
          },
          playerCount: players.length,
        ),
      ),
    );

    if (!mounted) return;
    if (selectedGames != null) {
      setState(() {
        _selectedGames = selectedGames;
      });
    }
  }

  void _navigateToGamePage() {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    players = playerProvider.players.keys.toList();

    if (players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one player to start the game.")),
      );
      return;
    }
    if (_selectedGames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one game to start.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          players: players,
          rounds: _rounds,
          availableGames: _selectedGames,
          onQuit: () {
            setState(() {
              _selectedGames = List.from(availableGames);
            });
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);


    final BoxDecoration backgroundGradient = themeNotifier.isDarkTheme
        ? AppThemes.darkBackgroundGradient
        : themeNotifier.isCustomTheme
        ? AppThemes.customBackgroundGradient
        : AppThemes.lightBackgroundGradient;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              if (value == 'Light') themeNotifier.setThemeMode(ThemeMode.light);
              if (value == 'Dark') themeNotifier.setThemeMode(ThemeMode.dark);
              if (value == 'Custom') themeNotifier.setCustomTheme();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Light', child: Text('Light Theme')),
              const PopupMenuItem(value: 'Dark', child: Text('Dark Theme')),
              const PopupMenuItem(value: 'Custom', child: Text('Custom Theme')),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: backgroundGradient,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA0UTfT73CQZwJmfedJSzlS0SJEt8hTT-QPQ&s',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Players",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPlayerInput(),
              const SizedBox(height: 8),
              _buildPlayerList(),
              const SizedBox(height: 8),
              const Text("Rounds", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildRoundsDropdown(),
              const SizedBox(height: 16),
              AnimatedButton(
                label: "Start Game",
                onPressed: _navigateToGamePage,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  Widget _buildRoundsDropdown() {
    return DropdownButton<int>(
        value: _rounds,
        dropdownColor: Colors.grey[200],
        items: List.generate(10, (index) => index + 1)
        .map((value) => DropdownMenuItem<int>(
    value: value,
    child: Text("$value"),
    ))
        .toList(),
    onChanged: (value) {
    setState(() {
    _rounds = value ?? 1;
    }); },
    );
  }

  Widget _buildPlayerInput() {
    return TextField(
      controller: _playerController,
      onSubmitted: _addPlayer,
      decoration: InputDecoration(
        hintText: "Enter player name",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _addPlayer(_playerController.text.trim()),
        ),
      ),
    );
  }

  Widget _buildPlayerList() {
    return Expanded(
      child: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final playerName = players[index];
          return GradientCard(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            title: playerName,
            subtitle: "Player details",
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removePlayer(playerName),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AnimatedButton(
            label: "Select Games",
            onPressed: _navigateToGameSelectionPage,
          ),
          AnimatedButton(
            label: "Dashboard",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
          AnimatedButton(
            label: "Help",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
