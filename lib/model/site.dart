import 'package:flutter/material.dart';
import 'package:winplant/assets.dart';
import 'package:winplant/model/plant.dart';
import 'package:winplant/model/plant_info.dart';

/// Represents the user's garden.
class Site {
  final String name;
  final Light light;
  final List<Plant> plants;
  final AssetImage image;

  Site({required this.name, required this.light, AssetImage? image})
      : plants = List<Plant>.empty(growable: true),
        image = image ?? emptyImage();

  /// Add plant to the garden - plant it.
  void addPlant(Plant plant) {
    plants.add(plant);
  }

  /// Remove the plant from the garden.
  void removePlant(Plant plant) {
    var removed = plants.remove(plant);
    assert(removed);
  }
}
