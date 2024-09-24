import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winplant/model/dummy_data.dart' as dummy;
import 'package:winplant/model/plant_info.dart';
import 'package:winplant/widgets/plant_info_preview_widget.dart';

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
                ?.map((plant) => PlantInfoPreviewWidget(plant: plant))
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

  Future<List<PlantInfo>> _fetchAllPlants() async {
    return dummy.allPlants();
  }
}
