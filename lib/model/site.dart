import 'package:winplant/model/plant.dart';

class Site {
  final String name;
  final Light light;
  final List<Plant> _plants;

  Site({required this.name, required this.light})
      : _plants = List<Plant>.empty(growable: true);

  void addPlant(Plant plant) {
    _plants.add(plant);
  }

  void removePlant(Plant plant) {
    var removed = _plants.remove(plant);
    assert(removed);
  }
}
