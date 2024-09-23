import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:winplant/model/plant.dart';
import 'package:winplant/model/site.dart';

Future<Plant> monsteraStadleyana() async {
  return Plant(
      name: 'Monstera Stadleyana',
      description: await _description("assets/monstera-standleyana.md"),
      image: const AssetImage('assets/monstera-standleyana.png'),
      category: Category.tropical,
      difficulty: Difficulty.easy,
      light: Light.partialSun,
      water: Water.lowWater,
      maxHeight: 25);
}

Future<Plant> aglaonema() async {
  return Plant(
      name: 'Aglaonema',
      description: await _description("assets/aglaonema-red-zircon.md"),
      image: const AssetImage('assets/aglaonema-red-zircon.png'),
      category: Category.subtropical,
      difficulty: Difficulty.easy,
      light: Light.partialSun,
      water: Water.fullWater,
      maxHeight: 25);
}

Future<Plant> hoyaTricolor() async {
  return Plant(
      name: 'Hoya Tricolor',
      description: await _description("assets/hoya-tricolor.md"),
      image: const AssetImage('assets/hoya-tricolor.png'),
      category: Category.tropical,
      difficulty: Difficulty.easy,
      light: Light.fullSun,
      water: Water.lowWater,
      maxHeight: 12);
}

Future<Plant> philodendronRedSun() async {
  return Plant(
      name: 'Philodendron Red Sun',
      description: await _description("assets/philodendron_red_sun.md"),
      image: const AssetImage('assets/philodendron_red_sun.png'),
      category: Category.tropical,
      difficulty: Difficulty.easy,
      light: Light.partialSun,
      water: Water.lowWater,
      maxHeight: 10);
}

Future<Plant> syngoniumPixie() async {
  return Plant(
      name: 'Syngonium Pixie',
      description: await _description("assets/syngonium_pixie.md"),
      image: const AssetImage('assets/syngonium_pixie.png'),
      category: Category.tropical,
      difficulty: Difficulty.easy,
      light: Light.partialSun,
      water: Water.fullWater,
      maxHeight: 12);
}

Future<List<Plant>> allPlants() async {
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
    name: 'obyvak',
    image: const AssetImage('assets/living_room.png'),
    light: Light.partialSun,
  );
  site.addPlant(await monsteraStadleyana());
  site.addPlant(await aglaonema());
  site.addPlant(await hoyaTricolor());
  return site;
}

Future<Site> kitchen() async {
  var site = Site(
    name: 'Kuchyne',
    image: const AssetImage('assets/kitchen.png'),
    light: Light.fullSun,
  );
  site.addPlant(await philodendronRedSun());
  site.addPlant(await syngoniumPixie());
  return site;
}

Future<List<Site>> allSites() async {
  return [await livingRoom(), await kitchen()];
}

Future<String> _description(String assetName) async {
  var markdownContent = await rootBundle.loadString(assetName);
  return markdownContent;
}
