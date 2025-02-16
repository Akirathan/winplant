import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winplant/data/utils.dart';
import 'package:winplant/model/plant_model.dart';
import 'package:winplant/widgets/plant_model_preview_widget.dart';

class PlantCatalogueWidget extends StatelessWidget {
  const PlantCatalogueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchAllPlants(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              var plantWidgets =
                  snapshot.data!.map((p) => PlantModelPreviewWidget(plant: p));
              return ListView(
                children: plantWidgets.toList(),
              );
            } else {
              if (snapshot.hasError) {
                return Text('Error during plant fetching: ${snapshot.error}');
              } else {
                return const Text('No plants found: unknown error');
              }
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<List<PlantModel>> _fetchAllPlants() {
    var db = FirebaseFirestore.instance;
    var plants = fetchAllPlants(db);
    return plants.toList();
  }
}
