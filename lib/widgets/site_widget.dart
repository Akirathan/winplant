import 'package:flutter/cupertino.dart';
import 'package:winplant/model/site.dart';
import 'package:winplant/widgets/plant_widget.dart';
import 'package:winplant/widgets/tags.dart';

class SiteWidget extends StatelessWidget {
  final Site site;

  const SiteWidget({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    var plantWidgets =
        site.plants.map((plant) => PlantWidget(plant: plant)).toList();
    return Column(
      children: <Widget>[
        Flexible(child: Image(image: site.image)),
        Flexible(child: Text(site.name, style: const TextStyle(fontSize: 20))),
        Flexible(child: lightWidget(site.light)),
        const Flexible(child: Text('Plants:')),
        Expanded(
          child: ListView(children: plantWidgets),
        )
      ],
    );
  }
}
