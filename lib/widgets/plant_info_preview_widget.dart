import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winplant/model/plant_info.dart';
import 'package:winplant/routes.dart';

/// Preview of [PlantInfo].
class PlantInfoPreviewWidget extends StatelessWidget {
  final PlantInfo plant;

  const PlantInfoPreviewWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 200),
      child: Column(
        children: <Widget>[
          Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(
                    child: Image(
                      image: plant.image,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      plant.description,
                      style: const TextStyle(
                          fontSize: 13, fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )),
          Flexible(
            child: ElevatedButton(
              child: Text(plant.name, style: const TextStyle(fontSize: 17)),
              onPressed: () {
                Navigator.pushNamed(context, plantInfoRoute, arguments: plant);
              },
            ),
          )
        ],
      ),
    );
  }
}
