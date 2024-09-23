import 'package:flutter/material.dart';

class Plant {
  final String name;
  final String description;
  final AssetImage image;
  final Category category;
  final Difficulty difficulty;
  final Light light;
  final Water water;

  /// in cm
  final int maxHeight;

  Plant(
      {required this.name,
      required this.description,
      required this.image,
      required this.category,
      required this.difficulty,
      required this.light,
      required this.water,
      required this.maxHeight});
}

enum Category { tropical, subtropical }

enum Difficulty { easy, medium, hard }

enum Light { fullSun, partialSun, shade }

enum Water { fullWater, lowWater }
