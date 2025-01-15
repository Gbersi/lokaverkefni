
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/game_provider.dart';

class StorageService {
  static const String _playersKey = 'players';
  static const String _scoresKey = 'scores';
  static const String _selectedGamesKey = 'selectedGames';
  static const String _roundsKey = 'rounds';

  static Future<void> savePlayers(Map<String, Player> players) async {
    final prefs = await SharedPreferences.getInstance();
    final playerData = players.map((key, value) => MapEntry(key, jsonEncode(value.toMap())));
    await prefs.setString(_playersKey, jsonEncode(playerData));
  }

  static Future<Map<String, Player>> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_playersKey);
    if (data != null) {
      final playerMap = jsonDecode(data) as Map<String, dynamic>;
      return playerMap.map((key, value) => MapEntry(key, Player.fromMap(jsonDecode(value))));
    }
    return {};
  }


  static Future<void> saveScores(Map<String, int> scores) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scoresKey, jsonEncode(scores));
  }


  static Future<Map<String, int>> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_scoresKey);
    if (data != null) {
      return Map<String, int>.from(jsonDecode(data));
    }
    return {};
  }


  static Future<void> saveSelectedGames(List<String> selectedGames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedGamesKey, selectedGames);
  }


  static Future<List<String>> loadSelectedGames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_selectedGamesKey) ?? [];
  }

  static Future<void> saveRounds(int rounds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_roundsKey, rounds);
  }


  static Future<int> loadRounds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_roundsKey) ?? 1;
  }
}

