
import 'package:flutter/material.dart';
import 'package:winplant/widgets/plant_info_widget.dart';
import 'package:winplant/widgets/site_widget.dart';

import 'model/plant_info.dart';
import 'model/site.dart';

const plantInfoRoute = '/plant-info';
const siteRoute = '/site';

MaterialPageRoute<Scaffold> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case plantInfoRoute : {
      var plant = settings.arguments as PlantInfo;
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(plant.name),
          ),
          body: PlantInfoWidget(plant: plant),
        ),
      );
    }
    case siteRoute : {
      var site = settings.arguments as Site;
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(site.name),
          ),
          body: SiteWidget(site: site),
        ),
      );
    }
    default :
      throw Exception('Invalid route: ${settings.name}');
  }
}
