import 'package:flutter/material.dart';
import 'package:winplant/model/plant_model.dart';
import 'package:winplant/routes.dart';
import 'package:winplant/widgets/loading_image.dart';

/// Preview of [PlantModel].
class PlantModelPreviewWidget extends StatelessWidget {
  final PlantModel plant;

  const PlantModelPreviewWidget({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    var image = _firstImage();

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 200),
      child: Column(
        children: <Widget>[
          Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(child: image),
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

  Widget _firstImage() {
    var imageUrl = plant.imageLinks.first;
    return LoadingImageWidget(url: imageUrl, width: 200, height: 200);
  }
}
