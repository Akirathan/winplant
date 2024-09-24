import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:winplant/model/history.dart';
import 'package:winplant/model/plant.dart';
import 'package:winplant/model/plant_info.dart';
import 'package:winplant/model/site.dart';

Future<PlantInfo> monsteraStadleyana() async {
  return PlantInfo(
      name: 'Monstera Stadleyana',
      description: await _description("assets/monstera-standleyana.md"),
      image: const AssetImage('assets/monstera-standleyana.png'),
      category: Category.tropical,
      difficulty: Difficulty.easy,
      light: Light.partialSun,
      water: Water.lowWater,
      maxHeight: 25);
}

Future<PlantInfo> aglaonema() async {
  return PlantInfo(
      name: 'Aglaonema',
      description: await _description("assets/aglaonema-red-zircon.md"),
      image: const AssetImage('assets/aglaonema-red-zircon.png'),
      category: Category.subtropical,
      difficulty: Difficulty.easy,
      light: Light.partialSun,
      water: Water.fullWater,
      maxHeight: 25);
}

Future<PlantInfo> hoyaTricolor() async {
  return PlantInfo(
      name: 'Hoya Tricolor',
      description: await _description("assets/hoya-tricolor.md"),
      image: const AssetImage('assets/hoya-tricolor.png'),
      category: Category.tropical,
      difficulty: Difficulty.easy,
      light: Light.fullSun,
      water: Water.lowWater,
      maxHeight: 12);
}

Future<PlantInfo> philodendronRedSun() async {
  return PlantInfo(
      name: 'Philodendron Red Sun',
      description: await _description("assets/philodendron_red_sun.md"),
      image: const AssetImage('assets/philodendron_red_sun.png'),
      category: Category.tropical,
      difficulty: Difficulty.easy,
      light: Light.partialSun,
      water: Water.lowWater,
      maxHeight: 10);
}

Future<PlantInfo> syngoniumPixie() async {
  return PlantInfo(
      name: 'Syngonium Pixie',
      description: await _description("assets/syngonium_pixie.md"),
      image: const AssetImage('assets/syngonium_pixie.png'),
      category: Category.tropical,
      difficulty: Difficulty.easy,
      light: Light.partialSun,
      water: Water.fullWater,
      maxHeight: 12);
}

Future<List<PlantInfo>> allPlants() async {
  return [
    await monsteraStadleyana(),
    await aglaonema(),
    await hoyaTricolor(),
    await philodendronRedSun(),
    await syngoniumPixie()
  ];
}

Future<Site> livingRoom() async {
  var site = Site(
    name: 'Obyvak',
    image: const AssetImage('assets/living_room.png'),
    light: Light.partialSun,
  );
  var monsteraTimeLine = TimeLine();
  monsteraTimeLine.addEvent(Watering(dateTime: DateTime.parse('2024-09-01')));
  monsteraTimeLine.addEvent(Fertilization(dateTime: DateTime.parse('2024-09-03')));
  monsteraTimeLine.addEvent(Note(dateTime: DateTime.parse('2024-09-10'), note: 'To mi to ale pekne roste!'));
  monsteraTimeLine.addEvent(Watering(dateTime: DateTime.parse('2024-09-12')));
  site.addPlant(Plant(info: await monsteraStadleyana(), timeLine: monsteraTimeLine));
  site.addPlant(Plant(info: await aglaonema(), timeLine: TimeLine()));
  return site;
}

Future<Site> kitchen() async {
  var site = Site(
    name: 'Kuchyne',
    image: const AssetImage('assets/kitchen.png'),
    light: Light.fullSun,
  );
  site.addPlant(Plant(info: await philodendronRedSun(), timeLine: TimeLine()));
  site.addPlant(Plant(info: await syngoniumPixie(), timeLine: TimeLine()));
  return site;
}

Future<List<Site>> allSites() async {
  return [await livingRoom(), await kitchen()];
}

Future<String> _description(String assetName) async {
  var markdownContent = await rootBundle.loadString(assetName);
  return markdownContent;
}
