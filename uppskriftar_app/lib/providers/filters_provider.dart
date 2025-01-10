import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../data/dummy_data.dart';
import '../models/meal_enums.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
  cookingTime15,
  cookingTime30,
  cookingTime60,
  easy,
  medium,
  hard,
}

class FilterSearchState {
  final Map<Filter, bool> filters;
  final String searchQuery;

  FilterSearchState({
    required this.filters,
    required this.searchQuery,
  });

  FilterSearchState copyWith({
    Map<Filter, bool>? filters,
    String? searchQuery,
  }) {
    return FilterSearchState(
      filters: filters ?? this.filters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class FilterSearchNotifier extends StateNotifier<FilterSearchState> {
  FilterSearchNotifier()
      : super(FilterSearchState(
    filters: {
      Filter.glutenFree: false,
      Filter.lactoseFree: false,
      Filter.vegetarian: false,
      Filter.vegan: false,
      Filter.cookingTime15: false,
      Filter.cookingTime30: false,
      Filter.cookingTime60: false,
      Filter.easy: false,
      Filter.medium: false,
      Filter.hard: false,
    },
    searchQuery: '',
  ));

  void setFilter(Filter filter, bool isActive) {
    state = state.copyWith(
      filters: {
        ...state.filters,
        filter: isActive,
      },
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.toLowerCase());
  }
}

final filterSearchProvider =
StateNotifierProvider<FilterSearchNotifier, FilterSearchState>(
      (ref) => FilterSearchNotifier(),
);

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = dummyMeals; // Replace with your actual meal data source
  final filterSearchState = ref.watch(filterSearchProvider);

  final filters = filterSearchState.filters;
  final searchQuery = filterSearchState.searchQuery;

  return allMeals.where((meal) {
    // Apply filters
    if (filters[Filter.glutenFree]! && !meal.isGlutenFree) return false;
    if (filters[Filter.lactoseFree]! && !meal.isLactoseFree) return false;
    if (filters[Filter.vegetarian]! && !meal.isVegetarian) return false;
    if (filters[Filter.vegan]! && !meal.isVegan) return false;

    // Apply cooking time filters
    if (filters[Filter.cookingTime15]! && meal.duration > 15) return false;
    if (filters[Filter.cookingTime30]! && meal.duration > 30) return false;
    if (filters[Filter.cookingTime60]! && meal.duration > 60) return false;

    // Apply difficulty filters
    if (filters[Filter.easy]! && meal.complexity != Complexity.easy) return false;
    if (filters[Filter.medium]! && meal.complexity != Complexity.medium) return false;
    if (filters[Filter.hard]! && meal.complexity != Complexity.hard) return false;

    // Apply search query
    if (searchQuery.isNotEmpty) {
      final matchesTitle = meal.title.toLowerCase().contains(searchQuery);
      final matchesIngredients = meal.ingredients.any(
            (ingredient) => ingredient.toLowerCase().contains(searchQuery),
      );
      return matchesTitle || matchesIngredients;
    }

    return true;
  }).toList();
});
