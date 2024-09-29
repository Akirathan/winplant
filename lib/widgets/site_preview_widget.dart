import 'package:flutter/material.dart';
import 'package:winplant/model/plant.dart';
import 'package:winplant/model/site.dart';
import 'package:winplant/routes.dart';
import 'package:winplant/widgets/tags.dart';

class SitePreviewWidget extends StatelessWidget {
  final Site site;

  const SitePreviewWidget({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    var smallPlantPreviews = site.plants.map((plant) => _plantSmallPreview(context, plant));
    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey, width: 2, style: BorderStyle.solid),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(height: 200),
          child: Column(
            children: [
              Flexible(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, siteRoute,
                            arguments: site);
                      },
                      child: Text(site.name,
                          style: const TextStyle(fontSize: 17)))),
              Flexible(fit: FlexFit.loose, child: lightWidget(site.light)),
              Expanded(
                flex: 3,
                child: Scrollbar(
                  thumbVisibility: false,
                  trackVisibility: false,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    itemExtent: 100,
                    children: smallPlantPreviews.toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _plantSmallPreview(BuildContext context, Plant plant) {
    var image = plant.image ?? plant.info.image;
    var name = plant.name ?? plant.info.name;
    return Container(
      constraints: const BoxConstraints.tightFor(height: 50, width: 100),
      child: Row(
        children: [
          Flexible(child: Image(image: image, fit: BoxFit.scaleDown)),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 8)
            )
          )
        ]
      ),
    );
  }
}
