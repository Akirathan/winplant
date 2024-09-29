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
  final List<Plant> _allPlants = List.empty(growable: true);
  late List<Site> _sites;

  @override
  void initState() {
    super.initState();
    _fetchAllSites().then((result) => {
      setState(() {
        _sites = result;
        for (var site in _sites) {
          for (var plant in site.plants) {
            _allPlants.add(plant);
          }
        }
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
            child: TabBar(
              tabs: [
                const Tab(
                  icon: Icon(Icons.location_city),
                  text: 'By Sites',
                ),
                Tab(
                  icon: Icon(Icons.eco_outlined, color: Colors.green.shade300),
                  text: 'By Plants',
                )
              ],
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

    return ListView(
      children: plantWidgets.toList()
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
}

