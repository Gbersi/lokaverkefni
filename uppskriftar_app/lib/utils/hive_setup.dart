import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal.dart';
import '../models/meal_enums.dart';

Future<void> initializeHive() async {
  await Hive.initFlutter();


  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(AffordabilityAdapter());
  Hive.registerAdapter(ComplexityAdapter());


  if (!Hive.isBoxOpen('recipes')) {
    await Hive.openBox<Meal>('recipes');
  }
  if (!Hive.isBoxOpen('userRecipes')) {
    await Hive.openBox<Meal>('userRecipes');
  }
  if (!Hive.isBoxOpen('favorites')) {
    await Hive.openBox<String>('favorites');
  }
}
