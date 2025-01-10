// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AffordabilityAdapter extends TypeAdapter<Affordability> {
  @override
  final int typeId = 2;

  @override
  Affordability read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Affordability.affordable;
      case 1:
        return Affordability.pricey;
      case 2:
        return Affordability.luxurious;
      default:
        return Affordability.affordable;
    }
  }

  @override
  void write(BinaryWriter writer, Affordability obj) {
    switch (obj) {
      case Affordability.affordable:
        writer.writeByte(0);
        break;
      case Affordability.pricey:
        writer.writeByte(1);
        break;
      case Affordability.luxurious:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AffordabilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ComplexityAdapter extends TypeAdapter<Complexity> {
  @override
  final int typeId = 3;

  @override
  Complexity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Complexity.simple;
      case 1:
        return Complexity.challenging;
      case 2:
        return Complexity.hard;
      default:
        return Complexity.simple;
    }
  }

  @override
  void write(BinaryWriter writer, Complexity obj) {
    switch (obj) {
      case Complexity.simple:
        writer.writeByte(0);
        break;
      case Complexity.challenging:
        writer.writeByte(1);
        break;
      case Complexity.hard:
        writer.writeByte(2);
        break;
      case Complexity.easy:
        // TODO: Handle this case.
      case Complexity.medium:
        // TODO: Handle this case.
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplexityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
