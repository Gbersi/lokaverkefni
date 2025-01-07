import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class StoreData {
  StoreData._privateConstructor();

  static final StoreData instance = StoreData._privateConstructor();

  Future<void> saveRecipes(List<Meal> recipes) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final encodedRecipes = jsonEncode(
        recipes.map((meal) => meal.toJson()).toList(),
      );
      await pref.setString('userRecipes', encodedRecipes);
    } catch (e) {
      print('saveRecipes ${e.toString()}');
    }
  }

  Future<List<Meal>> getRecipes() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final recipesString = pref.getString('userRecipes') ?? '[]';
      final List<dynamic> decodedRecipes = jsonDecode(recipesString);

      return decodedRecipes.map((mealJson) => Meal.fromJson(mealJson)).toList();
    } catch (e) {
      print('getRecipes ${e.toString()}');
      return [];
    }
  }

  Future<void> clearRecipes() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('userRecipes');
  }
}
