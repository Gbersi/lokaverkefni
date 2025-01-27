
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_selection_page.dart';
import '../models/games.dart';
import '../providers/game_provider.dart';
import '../widgets/animated_button.dart';
import '../widgets/gradient_card.dart';
import 'dashboard_page.dart';
import 'game_page.dart';
import 'onboarding_page.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  List<String> players = [];
  List<Game> availableGames = getGames();
  List<Game> _selectedGames = List.from(getGames());
  final TextEditingController _playerController = TextEditingController();
  int _rounds = 1;
  ThemeData _currentTheme = ThemeData.light();
  String _selectedTheme = 'Light';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      setState(() {
        players = gameProvider.players.keys.toList();
        _selectedGames = List.from(availableGames);
      });
    });
  }

  void _addPlayer(String playerName) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (playerName.isNotEmpty && !gameProvider.players.containsKey(playerName)) {
      gameProvider.addPlayer(playerName, 'https://example.com/default-avatar.png');
      setState(() {
        players = gameProvider.players.keys.toList();
        _playerController.clear();
      });
    }
  }

  void _removePlayer(String playerName) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.removePlayer(playerName);
    setState(() {
      players = gameProvider.players.keys.toList();
    });
  }

  void _changeTheme(String? theme) {
    if (theme != null) {
      setState(() {
        _selectedTheme = theme;
        switch (theme) {
          case 'Dark':
            _currentTheme = ThemeData.dark();
            break;
          case 'Custom':
            _currentTheme = ThemeData(
              primarySwatch: Colors.purple,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.purple.shade50,
              appBarTheme: const AppBarTheme(color: Colors.purple),
            );
            break;
          case 'Light':
          default:
            _currentTheme = ThemeData.light();
        }
      });
    }
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
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    players = gameProvider.players.keys.toList();

    if (players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("vinsamlegast bættu við a.m.k einum spilara.")),
      );
      return;
    }
    if (_selectedGames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("vinsamlegast veldu a.m.k einn leik til að spila.")),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Theme(
      data: _currentTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aðal Valmynd'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings),
              onSelected: _changeTheme,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Light',
                  child: Row(
                    children: [
                      if (_selectedTheme == 'Light') const Icon(Icons.check, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('Light Theme'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Dark',
                  child: Row(
                    children: [
                      if (_selectedTheme == 'Dark') const Icon(Icons.check, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('Dark Theme'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Custom',
                  child: Row(
                    children: [
                      if (_selectedTheme == 'Custom') const Icon(Icons.check, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('Custom Theme'),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: _buildBody(isWideScreen),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBody(bool isWideScreen) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 32 : 16, vertical: 16),
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
              "Leikmenn",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPlayerInput(),
            const SizedBox(height: 8),
            _buildPlayerList(),
            const SizedBox(height: 8),
            _buildRoundsDropdown(),
            const SizedBox(height: 16),
            AnimatedButton(
              label: "Spila Leik",
              onPressed: _navigateToGamePage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerInput() {
    return TextField(
      controller: _playerController,
      onSubmitted: _addPlayer,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: "Sláðu inn nafn leikmanns",
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
            subtitle: "upplýsingar um leikmann",
            titleStyle: const TextStyle(fontSize: 14),
            subtitleStyle: const TextStyle(fontSize: 12),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removePlayer(playerName),
            ),
          );
        },
      ),
    );
  }
  Widget _buildRoundsDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Lotur: ",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        DropdownButton<int>(
          value: _rounds,
          dropdownColor: Colors.grey[800],
          items: List.generate(10, (index) => index + 1)
              .map((value) => DropdownMenuItem<int>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _rounds = value ?? 1;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AnimatedButton(
              label: "Velja Leiki",
              onPressed: _navigateToGameSelectionPage,
            ),
            AnimatedButton(
              label: "Upplýsingar",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                );
              },
            ),
            AnimatedButton(
              label: "Hjálp",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
