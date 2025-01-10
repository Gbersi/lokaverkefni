// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 1;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      id: fields[0] as String,
      categories: (fields[1] as List).cast<String>(),
      title: fields[2] as String,
      imageUrl: fields[3] as String,
      ingredients: (fields[4] as List).cast<String>(),
      steps: (fields[5] as List).cast<String>(),
      duration: fields[6] as int,
      affordability: fields[7] as Affordability,
      complexity: fields[8] as Complexity,
      isGlutenFree: fields[9] as bool,
      isLactoseFree: fields[10] as bool,
      isVegetarian: fields[11] as bool,
      isVegan: fields[12] as bool,
      popularity: fields[13] as int,
      note: fields[14] as String?,
      rating: fields[15] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categories)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.ingredients)
      ..writeByte(5)
      ..write(obj.steps)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.affordability)
      ..writeByte(8)
      ..write(obj.complexity)
      ..writeByte(9)
      ..write(obj.isGlutenFree)
      ..writeByte(10)
      ..write(obj.isLactoseFree)
      ..writeByte(11)
      ..write(obj.isVegetarian)
      ..writeByte(12)
      ..write(obj.isVegan)
      ..writeByte(13)
      ..write(obj.popularity)
      ..writeByte(14)
      ..write(obj.note)
      ..writeByte(15)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
