
part of 'meal.dart';

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 1;

  @override
  Meal read(BinaryReader reader) {
    return Meal(
      id: reader.readString(),
      categories: reader.readList().cast<String>(),
      title: reader.readString(),
      imageUrl: reader.readString(),
      ingredients: reader.readList().cast<String>(),
      steps: reader.readList().cast<String>(),
      duration: reader.readInt(),
      affordability: Affordability.values[reader.readInt()],
      complexity: Complexity.values[reader.readInt()],
      isGlutenFree: reader.readBool(),
      isLactoseFree: reader.readBool(),
      isVegetarian: reader.readBool(),
      isVegan: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeString(obj.id)
      ..writeList(obj.categories)
      ..writeString(obj.title)
      ..writeString(obj.imageUrl)
      ..writeList(obj.ingredients)
      ..writeList(obj.steps)
      ..writeInt(obj.duration)
      ..writeInt(obj.affordability.index)
      ..writeInt(obj.complexity.index)
      ..writeBool(obj.isGlutenFree)
      ..writeBool(obj.isLactoseFree)
      ..writeBool(obj.isVegetarian)
      ..writeBool(obj.isVegan);
  }
}
