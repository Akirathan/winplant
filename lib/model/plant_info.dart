import 'package:flutter/material.dart';

/// Information about plant as fetched from the catalogue.
class PlantInfo {
  final String name;
  final String description;
  final AssetImage image;
  final Category category;
  final Difficulty difficulty;
  final Light light;
  final Water water;

  /// in cm
  final int maxHeight;

  PlantInfo(
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
