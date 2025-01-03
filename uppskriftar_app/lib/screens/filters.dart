import 'dart:core';
import 'package:flutter/material.dart';
import 'package:uppskriftar_app/providers/filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  Widget _buildSwitchListTile({
    required String title,
    required String description,
    required bool currentValue,
    required Function(bool) updateValue,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(description),
      value: currentValue,
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);
    final filtersNotifier = ref.read(filtersProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: Column(
        children: [
          _buildSwitchListTile(
            title: 'Gluten-Free',
            description: 'Only include gluten-free meals.',
            currentValue: activeFilters[Filter.glutenFree]!,
            updateValue: (value) {
              filtersNotifier.setFilter(Filter.glutenFree, value);
            },
          ),
          _buildSwitchListTile(
            title: 'Lactose-Free',
            description: 'Only include lactose-free meals.',
            currentValue: activeFilters[Filter.lactoseFree]!,
            updateValue: (value) {
              filtersNotifier.setFilter(Filter.lactoseFree, value);
            },
          ),
          _buildSwitchListTile(
            title: 'Vegetarian',
            description: 'Only include vegetarian meals.',
            currentValue: activeFilters[Filter.vegetarian]!,
            updateValue: (value) {
              filtersNotifier.setFilter(Filter.vegetarian, value);
            },
          ),
          _buildSwitchListTile(
            title: 'Vegan',
            description: 'Only include vegan meals.',
            currentValue: activeFilters[Filter.vegan]!,
            updateValue: (value) {
              filtersNotifier.setFilter(Filter.vegan, value);
            },
          ),
        ],
      ),
    );
  }
}
