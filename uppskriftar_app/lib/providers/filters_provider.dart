import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

// Unified filter and search state
class FilterSearchState {
  final Map<Filter, bool> filters;
  final String searchQuery;

  FilterSearchState({required this.filters, required this.searchQuery});

  FilterSearchState copyWith({Map<Filter, bool>? filters, String? searchQuery}) {
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

// Dynamically filter meals based on search query and filters
final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider);
  final filterSearchState = ref.watch(filterSearchProvider);

  final filters = filterSearchState.filters;
  final searchQuery = filterSearchState.searchQuery;

  return allMeals.where((meal) {
    // Apply filters
    if (filters[Filter.glutenFree]! && !meal.isGlutenFree) return false;
    if (filters[Filter.lactoseFree]! && !meal.isLactoseFree) return false;
    if (filters[Filter.vegetarian]! && !meal.isVegetarian) return false;
    if (filters[Filter.vegan]! && !meal.isVegan) return false;

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
