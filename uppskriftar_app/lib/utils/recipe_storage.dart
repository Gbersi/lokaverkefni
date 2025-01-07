import 'package:hive/hive.dart';
import '../models/meal.dart';

class RecipeStorage {
  static late Box<Meal> _box;

  static Future<void> initialize() async {
    if (!Hive.isBoxOpen('userRecipes')) {
      _box = await Hive.openBox<Meal>('userRecipes');
    } else {
      _box = Hive.box<Meal>('userRecipes');
    }
  }

  static Future<void> saveRecipes(List<Meal> recipes) async {
    await _box.clear();
    await _box.addAll(recipes);
  }

  static List<Meal> getRecipes() {
    return _box.values.toList();
  }

  static Future<void> clearRecipes() async {
    await _box.clear();
  }
}
