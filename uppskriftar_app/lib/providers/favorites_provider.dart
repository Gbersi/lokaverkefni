import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/meal.dart';
import '../data/dummy_data.dart';

class FavoritesNotifier extends StateNotifier<List<Meal>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  final Box<String> _favoritesBox = Hive.box<String>('favorites');

  void _loadFavorites() {
    final favoriteIds = _favoritesBox.values.toList();
    final List<Meal> favorites = dummyMeals.where((meal) => favoriteIds.contains(meal.id)).toList();
    state = favorites;
  }

  void toggleFavorite(Meal meal) {
    if (state.contains(meal)) {
      _removeFromFavorites(meal);
    } else {
      _addToFavorites(meal);
    }
  }

  void _addToFavorites(Meal meal) {
    _favoritesBox.put(meal.id, meal.id);
    state = [...state, meal];
  }

  void _removeFromFavorites(Meal meal) {
    _favoritesBox.delete(meal.id);
    state = state.where((m) => m.id != meal.id).toList();
  }

  bool isFavorite(Meal meal) {
    return state.contains(meal);
  }

  void updateNoteOrRating(Meal meal, {String? note, double? rating}) {
    final updatedMeal = meal.copyWith(note: note, rating: rating);
    final updatedFavorites = state.map((m) {
      if (m.id == meal.id) return updatedMeal;
      return m;
    }).toList();
    state = updatedFavorites;
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Meal>>((ref) {
  return FavoritesNotifier();
});
