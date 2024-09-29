import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:winplant/model/plant.dart';
import 'package:winplant/model/site.dart';
import 'package:winplant/routes.dart';
import 'package:winplant/widgets/site_preview_widget.dart';
import 'package:winplant/model/dummy_data.dart' as dummy;

/// Displays garden - two tabs - by sites and by plants
class GardenWidget extends StatefulWidget {
  const GardenWidget({super.key});

  @override
  State<GardenWidget> createState() => _GardenWidgetState();
}

class _GardenWidgetState extends State<GardenWidget> {
  bool _isLoading = true;
  List<Plant> _allPlants = List.empty(growable: true);
  late List<Site> _sites;

  @override
  void initState() {
    super.initState();
    _fetchAllSites().then((result) => {
      setState(() {
        _sites = result;
            _allPlants = _plantsFromSites(_sites).toList();
            _isLoading = false;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    var sitePreviews = _sites.map((site) => SitePreviewWidget(site: site)).toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 50),
              child: TabBar(
                tabs: [
                  const Tab(
                    icon: Icon(Icons.location_city),
                    text: 'By Sites',
                  ),
                  Tab(
                    icon:
                        Icon(Icons.eco_outlined, color: Colors.green.shade300),
                    text: 'By Plants',
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: TabBarView(
                children: [
                  _buildSiteList(sitePreviews),
                  _buildPlantList(context)
                ]
            ),
          )
        ],
      ),
    );
  }

  Future<List<Site>> _fetchAllSites() async {
    return dummy.allSites();
  }

  /// Under "By Sites" tab
  Widget _buildSiteList(List<SitePreviewWidget> sitePreviews) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: ListView(children: sitePreviews),
        ),
        //const Spacer(),
        const Flexible(
          child: Padding(
              padding: EdgeInsets.only(left: 200),
              child: IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  size: 70,
                  color: Colors.green,
                ),
                // TODO: Add new site widget
                onPressed: null,
                tooltip: 'Add new site',
              )),
        )
      ]);
  }

  /// Under "By Plants" tab
  Widget _buildPlantList(BuildContext context) {
    var plantWidgets = _allPlants.map((plant) {
      var name = plant.name ?? plant.info.name;
      var image = plant.image ?? plant.info.image;
      return Container(
        constraints: const BoxConstraints.tightFor(height: 80, width: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        // An elevated button that looks like a Card for a plant.
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, plantRoute, arguments: plant);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(name)
                      ),
                      Flexible(
                        child: Text(
                          _siteForPlant(plant).name,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade800
                          )
                        )
                      )
                    ],
                  )
                ),
                Flexible(
                  child: Image(
                    image: image,
                    fit: BoxFit.scaleDown
                  )
                )
              ]
            ),
          ),
        ),
      );
    });

    var searchPlant = Container(
      constraints: const BoxConstraints.tightFor(height: 35),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search plant',
          hintText: 'Enter a plant name',
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
          icon: Icon(Icons.search),
        ),
        onChanged: (String text) {
          if (text.isEmpty) {
            setState(() {
              _allPlants = _plantsFromSites(_sites).toList();
            });
            return;
          }
          var matchingPlants = _matchingPlants(text);
          var matchingNames =
              matchingPlants.map((plant) => _nameForPlant(plant));
          log('Matching plants for text $text: $matchingNames');
          setState(() {
            _allPlants = matchingPlants.toList(growable: true);
          });
        },
      ),
    );

    var addPlant = IconButton(
        icon: const Icon(
          Icons.add_circle_rounded,
          color: Colors.green,
        ),
        onPressed: () {
          // TODO: Add plant
        });

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: searchPlant),
        Expanded(
          flex: 6,
          child: ListView(children: plantWidgets.toList()),
        ),
        Flexible(child: addPlant)
      ],
    );
  }

  Site _siteForPlant(Plant plant) {
    for (var site in _sites) {
      if (site.plants.contains(plant)) {
        return site;
      }
    }
    throw Exception('Plant not found in any site');
  }

  Iterable<Plant> _matchingPlants(String name) {
    return _allPlants.where((plant) => _nameMatches(name, plant));
  }
}

String _nameForPlant(Plant plant) {
  return plant.name ?? plant.info.name;
}

String _normalizedName(String name) {
  return name.toLowerCase();
}

bool _nameMatches(String name, Plant plant) {
  return _normalizedName(_nameForPlant(plant)).contains(name);
}

Iterable<Plant> _plantsFromSites(List<Site> sites) {
  var plants = <Plant>[];
  for (var site in sites) {
    plants.addAll(site.plants);
  }
  return plants;
}
