import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as Meal;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              meal.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            ...meal.ingredients.map((ingredient) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('- $ingredient'),
            )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
            ...meal.steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text('$step'),
            )),
          ],
        ),
      ),
    );
  }
}
