import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filters_provider.dart';
import '../widgets/category_grid_item.dart';
import '../widgets/meal_item.dart';
import 'meals.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredMeals = ref.watch(filteredMealsProvider);
    final searchQuery = ref.watch(filterSearchProvider).searchQuery;
    final filterSearchNotifier = ref.read(filterSearchProvider.notifier);

    final dummyCategories = [
      {'id': 'c1', 'title': 'Italian', 'color': Colors.purple},
      {'id': 'c2', 'title': 'Quick & Easy', 'color': Colors.red},
      {'id': 'c3', 'title': 'Hamburgers', 'color': Colors.orange},
      {'id': 'c4', 'title': 'German', 'color': Colors.amber},
      {'id': 'c5', 'title': 'Light & Lovely', 'color': Colors.blue},
      {'id': 'c6', 'title': 'Exotic', 'color': Colors.green},
      {'id': 'c7', 'title': 'Breakfast', 'color': Colors.lightBlue},
      {'id': 'c8', 'title': 'Asian', 'color': Colors.lightGreen},
      {'id': 'c9', 'title': 'French', 'color': Colors.pink},
      {'id': 'c10', 'title': 'Summer', 'color': Colors.teal},
      {'id': 'your-recipes', 'title': 'Your Recipes', 'color': Colors.brown},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search Recipes',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (query) {
              filterSearchNotifier.setSearchQuery(query);
            },
          ),
        ),
        Expanded(
          child: searchQuery.isNotEmpty
              ? ListView.builder(
            itemCount: filteredMeals.length,
            itemBuilder: (ctx, index) {
              final meal = filteredMeals[index];
              return MealItem(
                meal: meal,
                onSelectMeal: () {
                  Navigator.of(context).pushNamed(
                    '/meal-details',
                    arguments: meal,
                  );
                },
              );
            },
          )
              : GridView(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: dummyCategories.map((catData) {
              return CategoryGridItem(
                id: catData['id'] as String,
                title: catData['title'] as String,
                color: catData['color'] as Color,
                onSelectCategory: () {
                  final categoryMeals = filteredMeals.where((meal) {
                    return meal.categories.contains(catData['id']);
                  }).toList();

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => MealsScreen(
                        title: catData['title'] as String,
                        meals: categoryMeals,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

