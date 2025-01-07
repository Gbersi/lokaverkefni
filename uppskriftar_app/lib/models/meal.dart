import 'package:hive/hive.dart';
import 'meal_enums.dart';

part 'meal.g.dart';

@HiveType(typeId: 1)
class Meal {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<String> categories;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final List<String> ingredients;

  @HiveField(5)
  final List<String> steps;

  @HiveField(6)
  final int duration;

  @HiveField(7)
  final Affordability affordability;

  @HiveField(8)
  final Complexity complexity;

  @HiveField(9)
  final bool isGlutenFree;

  @HiveField(10)
  final bool isLactoseFree;

  @HiveField(11)
  final bool isVegetarian;

  @HiveField(12)
  final bool isVegan;

  const Meal({
    required this.id,
    required this.categories,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.affordability,
    required this.complexity,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegetarian,
    required this.isVegan,
  });

  // Convert Meal to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'categories': categories,
    'title': title,
    'imageUrl': imageUrl,
    'ingredients': ingredients,
    'steps': steps,
    'duration': duration,
    'affordability': affordability.name,
    'complexity': complexity.name,
    'isGlutenFree': isGlutenFree,
    'isLactoseFree': isLactoseFree,
    'isVegetarian': isVegetarian,
    'isVegan': isVegan,
  };

  // Create Meal from JSON
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      categories: List<String>.from(json['categories']),
      title: json['title'],
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
      duration: json['duration'],
      affordability: Affordability.values
          .firstWhere((e) => e.name == json['affordability']),
      complexity: Complexity.values
          .firstWhere((e) => e.name == json['complexity']),
      isGlutenFree: json['isGlutenFree'],
      isLactoseFree: json['isLactoseFree'],
      isVegetarian: json['isVegetarian'],
      isVegan: json['isVegan'],
    );
  }
}
