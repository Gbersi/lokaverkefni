import 'package:flutter/material.dart';

class CategoryGridItem extends StatelessWidget {
  final String id;
  final String title;
  final Color color;
  final VoidCallback onSelectCategory;

  const CategoryGridItem({
    super.key,
    required this.id,
    required this.title,
    required this.color,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectCategory,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
