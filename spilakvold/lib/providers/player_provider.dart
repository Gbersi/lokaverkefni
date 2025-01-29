import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class Player {
  final String name;
  final String? avatarUrl;
  int gamesPlayed = 0;
  int wins = 0;
  int losses = 0;

  Player({required this.name, this.avatarUrl});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
      'gamesPlayed': gamesPlayed,
      'wins': wins,
      'losses': losses,
    };
  }

  double get averageScore => gamesPlayed == 0 ? 0.0 : wins / gamesPlayed;

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'],
      avatarUrl: map['avatarUrl'],
    )
      ..gamesPlayed = map['gamesPlayed']
      ..wins = map['wins']
      ..losses = map['losses'];
  }
}

class PlayerProvider with ChangeNotifier {
  Map<String, Player> players = {};
  int highestScore = 0;
  String highestScorer = "";

  PlayerProvider() {
    _loadPlayerState();
  }

  Future<void> _loadPlayerState() async {
    players = await StorageService.loadPlayers();
    notifyListeners();
  }

  Future<void> savePlayerState() async {
    await StorageService.savePlayers(players);
  }

  void addPlayer(String name, [String? avatarUrl]) {
    if (!players.containsKey(name)) {
      players[name] = Player(name: name, avatarUrl: avatarUrl);
      savePlayerState();
      notifyListeners();
    }
  }

  void removePlayer(String name) {
    players.remove(name);
    savePlayerState();
    notifyListeners();
  }

  void updatePlayerStats(String name,
      {int gamesPlayed = 0, int wins = 0, int losses = 0}) {
    if (players.containsKey(name)) {
      players[name]!.gamesPlayed += gamesPlayed;
      players[name]!.wins += wins;
      players[name]!.losses += losses;

      if (players[name]!.wins > highestScore) {
        highestScore = players[name]!.wins;
        highestScorer = name;
      }

      savePlayerState();
      notifyListeners();
    }
  }

  Player? getPlayer(String name) {
    return players[name];
  }

  void checkAchievements(String player, int score) {
    if (score > highestScore) {
      highestScore = score;
      highestScorer = player;
    }
    notifyListeners();
  }

  void resetPlayers() {
    players.clear();
    highestScore = 0;
    highestScorer = "";
    savePlayerState();
    notifyListeners();
  }
}