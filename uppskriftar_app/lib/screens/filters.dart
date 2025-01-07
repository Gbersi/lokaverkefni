import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filters_provider.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filterSearchProvider).filters; // Get filters state
    final filtersNotifier = ref.read(filterSearchProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: Column(
        children: Filter.values.map((filter) {
          return SwitchListTile(
            title: Text(filter.name),
            value: filters[filter]!,
            onChanged: (value) {
              filtersNotifier.setFilter(filter, value);
            },
          );
        }).toList(),
      ),
    );
  }
}
