import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winplant/model/garden_plant_model.dart';

const sitesPath = 'sites';

class SiteModel {
  final String id;
  final String name;
  final List<String> gardenPlantIds;

  SiteModel(
      {required this.id, required this.name, required this.gardenPlantIds});

  static Future<SiteModel?> fetch(String siteId) async {
    var db = FirebaseFirestore.instance;
    var doc = await db.collection(sitesPath).doc(siteId).get();
    if (!doc.exists) {
      return null;
    } else {
      var data = doc.data()!;
      var plantIds = data['plants'] as List<String>;
      return SiteModel(
          id: siteId, name: data['name'], gardenPlantIds: plantIds);
    }
  }

  Stream<GardenPlantModel> gardenPlants() async* {
    for (var plantId in gardenPlantIds) {
      var plant = await GardenPlantModel.fetch(plantId);
      if (plant == null) {
        throw Exception('Plant not found: $plantId');
      }
      yield plant;
    }
  }

  Future<void> store() async {
    var db = FirebaseFirestore.instance;
    var doc = db.collection(sitesPath).doc(id);
    await doc.set({
      'name': name,
      'plants': gardenPlantIds,
    });
  }
}
