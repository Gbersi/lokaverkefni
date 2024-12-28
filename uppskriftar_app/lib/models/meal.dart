enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}


class Meal {
  final String id;
  final List<String> categories;
  final String title;
  final Affordability affordability;
  final Complexity complexity;
  final String imageUrl;
  final int duration;
  final List<String> ingredients;
  final List<String> steps;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;

  Meal({
    required this.id,
    required this.categories,
    required this.title,
    required this.affordability,
    required this.complexity,
    required this.imageUrl,
    required this.duration,
    required this.ingredients,
    required this.steps,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
  });

  Meal copyWith({List<String>? categories}) {
    return Meal(
      id: id,
      categories: categories ?? this.categories,
      title: title,
      affordability: affordability,
      complexity: complexity,
      imageUrl: imageUrl,
      duration: duration,
      ingredients: ingredients,
      steps: steps,
      isGlutenFree: isGlutenFree,
      isLactoseFree: isLactoseFree,
      isVegan: isVegan,
      isVegetarian: isVegetarian,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categories': categories,
      'title': title,
      'affordability': affordability.index,
      'complexity': complexity.index,
      'imageUrl': imageUrl,
      'duration': duration,
      'ingredients': ingredients,
      'steps': steps,
      'isGlutenFree': isGlutenFree,
      'isLactoseFree': isLactoseFree,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
    };
  }

  static Meal fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      categories: List<String>.from(json['categories']),
      title: json['title'],
      affordability: Affordability.values[json['affordability']],
      complexity: Complexity.values[json['complexity']],
      imageUrl: json['imageUrl'],
      duration: json['duration'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
      isGlutenFree: json['isGlutenFree'],
      isLactoseFree: json['isLactoseFree'],
      isVegan: json['isVegan'],
      isVegetarian: json['isVegetarian'],
    );
  }
}
