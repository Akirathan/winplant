import 'package:flutter/material.dart';
import 'package:winplant/model/site.dart';
import 'package:winplant/model/plant.dart';
import 'package:winplant/routes.dart';
import 'package:winplant/widgets/plant_info_widget.dart';
import 'package:winplant/widgets/tags.dart';


class SiteWidget extends StatelessWidget {
  final Site site;

  const SiteWidget({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    var plantPreviews = site.plants.map((plant) => _plantPreview(context, plant)).toList();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(flex: 2, child: Image(image: site.image)),
        Flexible(child: Text(site.name, style: const TextStyle(fontSize: 20))),
        Flexible(child: lightWidget(site.light)),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: ListView(children: plantPreviews),
          ),
        )
      ],
    );
  }

  Widget _plantPreview(BuildContext context, Plant plant) {
    AssetImage img = plant.image ?? plant.info.image;
    String name = plant.name ?? plant.info.name;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      constraints: const BoxConstraints.tightFor(height: 50, width: 200),
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushNamed(context, plantRoute, arguments: plant);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Image(image: img)),
            Flexible(child: Text(name)),
          ],
        )
      ),
    );
  }
}
