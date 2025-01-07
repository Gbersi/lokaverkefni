import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/dummy_data.dart';
import '../models/meal.dart';

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>(
      (ref) => MealsNotifier(),
);

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super(_loadInitialMeals());

  static List<Meal> _loadInitialMeals() {
    final userRecipesBox = Hive.box<Meal>('userRecipes');
    final userRecipes = userRecipesBox.values.cast<Meal?>().whereType<Meal>().toList();
    return [...dummyMeals, ...userRecipes];
  }

  void addMeal(Meal newMeal) async {
    final userRecipesBox = Hive.box<Meal>('userRecipes');
    await userRecipesBox.put(newMeal.id, newMeal);
    state = [...state, newMeal];
  }

  void deleteMeal(String mealId) async {
    final userRecipesBox = Hive.box<Meal>('userRecipes');
    await userRecipesBox.delete(mealId);
    state = state.where((meal) => meal.id != mealId).toList();
  }
}
