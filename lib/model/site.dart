import 'package:flutter/material.dart';
import 'package:winplant/model/plant.dart';

class Site {
  final String name;
  final Light light;
  final List<Plant> plants;
  final AssetImage image;

  Site({required this.name, required this.light, AssetImage? image})
      : plants = List<Plant>.empty(growable: true),
    image = image ?? const AssetImage('assets/empty_image.jpg');

  void addPlant(Plant plant) {
    plants.add(plant);
  }

  void removePlant(Plant plant) {
    var removed = plants.remove(plant);
    assert(removed);
  }
}
