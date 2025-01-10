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

  @HiveField(13)
  final int popularity;

  @HiveField(14)
  final String? note;

  @HiveField(15)
  final double? rating;

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
    this.popularity = 0,
    this.note,
    this.rating,
  });


  Meal copyWith({
    String? id,
    List<String>? categories,
    String? title,
    String? imageUrl,
    List<String>? ingredients,
    List<String>? steps,
    int? duration,
    Affordability? affordability,
    Complexity? complexity,
    bool? isGlutenFree,
    bool? isLactoseFree,
    bool? isVegetarian,
    bool? isVegan,
    int? popularity,
    String? note,
    double? rating,
  }) {
    return Meal(
      id: id ?? this.id,
      categories: categories ?? this.categories,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      duration: duration ?? this.duration,
      affordability: affordability ?? this.affordability,
      complexity: complexity ?? this.complexity,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isLactoseFree: isLactoseFree ?? this.isLactoseFree,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      popularity: popularity ?? this.popularity,
      note: note ?? this.note,
      rating: rating ?? this.rating,
    );
  }
}
