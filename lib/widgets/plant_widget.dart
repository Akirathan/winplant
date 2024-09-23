import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winplant/model/plant.dart';
import 'package:winplant/widgets/tags.dart';

/**
 * Plant as displayed in the catalogue.
 */
class PlantWidget extends StatelessWidget {
  final Plant plant;

  const PlantWidget({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Image(image: plant.image),
        Text(plant.name, style: const TextStyle(fontSize: 20)),
        _description(),
        _tags(),
      ],
    );
  }

  Widget _tags() {
    var children = <Widget>[
      lightWidget(plant.light),
      difficultyWidget(plant.difficulty),
      waterWidget(plant.water)
    ];
    return GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: children.length,
        shrinkWrap: true,
        children: children);
  }

  Widget _description() {
    return Text(
      plant.description,
    );
  }
}
