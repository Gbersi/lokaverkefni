import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealItem extends StatelessWidget {
  final Meal meal;
  final VoidCallback onSelectMeal;
  final VoidCallback? onDelete;

  const MealItem({
    super.key,
    required this.meal,
    required this.onSelectMeal,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectMeal,
      splashColor: Colors.teal,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    meal.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (onDelete != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(width: 6),
                      Text('${meal.duration} min'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.work),
                      const SizedBox(width: 6),
                      Text(meal.complexity.name),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(width: 6),
                      Text(meal.affordability.name),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
