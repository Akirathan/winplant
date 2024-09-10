import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:winplant/model/plant.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PlantCatalogue {
  static Future<Plant> monsteraStadleyana() async {
    return Plant(
        name: 'Monstera Stadleyana',
        description: await _markdown("assets/monstera-standleyana.md"),
        image: const AssetImage('assets/monstera-standleyana.png'),
        category: Category.tropical,
        difficulty: Difficulty.easy,
        light: Light.partialSun,
        water: Water.lowWater,
        maxHeight: 25);
  }

  static aglaonema() async {
    return Plant(
        name: 'Aglaonema',
        description: _markdown("assets/aglaonema-red-zircon.md"),
        image: const AssetImage('assets/aglaonema-red-zircon.png'),
        category: Category.subtropical,
        difficulty: Difficulty.easy,
        light: Light.partialSun,
        water: Water.fullWater,
        maxHeight: 25);
  }

  static hoyaTricolor() async {
    return Plant(
        name: 'Hoya Tricolor',
        description: _markdown("assets/hoya-tricolor.md"),
        image: const AssetImage('assets/hoya-tricolor.png'),
        category: Category.tropical,
        difficulty: Difficulty.easy,
        light: Light.fullSun,
        water: Water.lowWater,
        maxHeight: 12);
  }

  static _markdown(String assetName) async {
    var markdownContent = await rootBundle.loadString(assetName);
    return Markdown(
      data: markdownContent,
      shrinkWrap: true,
      softLineBreak: false,
    );
  }
}
