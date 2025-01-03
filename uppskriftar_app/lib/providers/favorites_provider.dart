import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/meal.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Meal>>(
      (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<List<Meal>> {
  FavoritesNotifier() : super(_loadInitialFavorites());

  static List<Meal> _loadInitialFavorites() {
    final favoritesBox = Hive.box<Meal>('favorites');
    return favoritesBox.values.toList();
  }

  void toggleFavorite(Meal meal) async {
    final favoritesBox = Hive.box<Meal>('favorites');
    if (isFavorite(meal)) {
      await favoritesBox.delete(meal.id); // Remove from favorites
      state = state.where((favorite) => favorite.id != meal.id).toList();
    } else {
      await favoritesBox.put(meal.id, meal); // Add to favorites
      state = [...state, meal];
    }
  }

  bool isFavorite(Meal meal) {
    return state.any((favorite) => favorite.id == meal.id);
  }
}
