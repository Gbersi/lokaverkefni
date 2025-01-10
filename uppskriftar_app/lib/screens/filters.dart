import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filters_provider.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filterSearchProvider);
    final filtersNotifier = ref.read(filterSearchProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Gluten-Free'),
            value: filters.filters[Filter.glutenFree]!,
            onChanged: (newValue) {
              filtersNotifier.setFilter(Filter.glutenFree, newValue);
            },
          ),
          SwitchListTile(
            title: const Text('Lactose-Free'),
            value: filters.filters[Filter.lactoseFree]!,
            onChanged: (newValue) {
              filtersNotifier.setFilter(Filter.lactoseFree, newValue);
            },
          ),
          SwitchListTile(
            title: const Text('Vegetarian'),
            value: filters.filters[Filter.vegetarian]!,
            onChanged: (newValue) {
              filtersNotifier.setFilter(Filter.vegetarian, newValue);
            },
          ),
          SwitchListTile(
            title: const Text('Vegan'),
            value: filters.filters[Filter.vegan]!,
            onChanged: (newValue) {
              filtersNotifier.setFilter(Filter.vegan, newValue);
            },
          ),
        ],
      ),
    );
  }
}
