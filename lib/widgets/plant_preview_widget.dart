import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winplant/model/plant.dart';

class PlantPreviewWidget extends StatelessWidget {
  final Plant plant;

  const PlantPreviewWidget({super.key, required this.plant});

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
                      fontSize: 13,
                      fontStyle: FontStyle.italic
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          ),
          Flexible(
            child: ElevatedButton(
              child: Text(plant.name, style: const TextStyle(fontSize: 17)),
              onPressed: () {
                Navigator.pushNamed(context, '/plant', arguments: plant);
              },
            ),
          )
        ],
      ),
    );
  }
}
