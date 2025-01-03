import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winplant/model/plant_model.dart';

import 'history.dart';

const gardenPlantPath = 'garden-plants';

/// Reference to a planted plant in the user's garden (site).
class GardenPlantModel {
  final String id;

  /// ID to the [PlantModel]. If null, this is a manually-created plant.
  final String? plantId;
  final String timelineId;

  GardenPlantModel(
      {required this.id, required this.plantId, required this.timelineId});

  static Future<GardenPlantModel?> fetch(String gardenPlantId) async {
    var db = FirebaseFirestore.instance;
    var doc = await db.collection(gardenPlantPath).doc(gardenPlantId).get();
    if (!doc.exists) {
      return null;
    } else {
      var data = doc.data()!;
      return GardenPlantModel(
          id: gardenPlantId,
          plantId: data['plantId'],
          timelineId: data['timelineId']);
    }
  }

  Future<void> store() async {
    var db = FirebaseFirestore.instance;
    var doc = db.collection(gardenPlantPath).doc(id);
    await doc.set(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'timelineId': timelineId,
    };
  }

  Future<TimeLine> timeline() async {
    var timeline = await TimeLine.fetch(timelineId);
    return timeline!;
  }
}
