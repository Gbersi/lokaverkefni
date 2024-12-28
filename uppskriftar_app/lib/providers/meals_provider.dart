import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';
import '../data/dummy_data.dart';

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super([...dummyMeals]) {
    _loadUserRecipes();
  }

  void addMeal(Meal newMeal) async {
    final userMeal = newMeal.copyWith(categories: ['your-recipes']);
    state = [...state, userMeal];
    await _saveUserRecipes();
  }

  void deleteMeal(String mealId) async {
    state = state.where((meal) {
      return !meal.categories.contains('your-recipes') || meal.id != mealId;
    }).toList();
    await _saveUserRecipes();
  }

  Future<void> _saveUserRecipes() async {
    final userRecipes = state.where((meal) => meal.categories.contains('your-recipes')).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userRecipes', jsonEncode(userRecipes.map((meal) => meal.toJson()).toList()));
  }

  Future<void> _loadUserRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final userRecipesData = prefs.getString('userRecipes');
    if (userRecipesData != null) {
      final List<dynamic> decodedData = jsonDecode(userRecipesData);
      final userRecipes = decodedData.map((data) => Meal.fromJson(data)).toList();
      state = [...dummyMeals, ...userRecipes];
    }
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  return MealsNotifier();
});
