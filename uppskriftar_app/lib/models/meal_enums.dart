import 'package:hive/hive.dart';

part 'meal_enums.g.dart'; // This tells Hive to generate the `meal_enums.g.dart` file

@HiveType(typeId: 2)
enum Affordability {
  @HiveField(0)
  affordable,
  @HiveField(1)
  pricey,
  @HiveField(2)
  luxurious,
}

@HiveType(typeId: 3)
enum Complexity {
  @HiveField(0)
  simple,
  @HiveField(1)
  challenging,
  @HiveField(2)
  hard, easy, medium,
}
