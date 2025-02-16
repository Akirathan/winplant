import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winplant/model/plant_model.dart';

typedef DocRef = DocumentReference<Map<String, dynamic>>;

Future<bool> docExists(DocumentReference<Map<String, dynamic>> docRef) async {
  var doc = await docRef.get();
  return doc.exists;
}

List<String> asStrList(dynamic data) {
  return (data as List<dynamic>).map((it) => it.toString()).toList();
}

Future<int> numberOfPlants(FirebaseFirestore db) async {
  var plantsCol = await db.collection('plants').get();
  return plantsCol.docs.length;
}

Stream<PlantModel> fetchAllPlants(FirebaseFirestore db) async* {
  var plantsCol = await db.collection('plants').get();
  for (var doc in plantsCol.docs) {
    var plant = await PlantModel.fetch(db, doc.id);
    yield plant!;
  }
}
