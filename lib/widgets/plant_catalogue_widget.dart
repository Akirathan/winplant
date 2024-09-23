import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winplant/model/dummy_data.dart' as dummy;
import 'package:winplant/model/plant.dart';
import 'package:winplant/widgets/plant_preview_widget.dart';
import 'package:winplant/widgets/plant_widget.dart';

class PlantCatalogueWidget extends StatelessWidget {
  const PlantCatalogueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var searchBar = const TextField(
      decoration: InputDecoration(
        hintText: 'Search for plant',
        prefixIcon: Icon(Icons.search),
      ),
    );

    return FutureBuilder(
        future: _fetchAllPlants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var plantWidgets = snapshot.data
                ?.map((plant) => PlantPreviewWidget(plant: plant))
                .toList();
            return Column(
              children: <Widget>[
                searchBar,
                Expanded(
                  child: ListView(children: plantWidgets!),
                )
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<List<Plant>> _fetchAllPlants() async {
    return dummy.allPlants();
  }
}
