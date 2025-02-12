
import 'package:cloud_firestore/cloud_firestore.dart';

const plantsCollectionPath = 'plants';

/// Information about plant as fetched from the catalogue.
class PlantModel {
  final String id;
  final String name;
  final String description;
  final List<Uri> imageLinks;
  final Map<String, String> tags;

  PlantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageLinks,
    required this.tags,
  });

  static Future<PlantModel?> fetch(FirebaseFirestore db, String plantId) async {
    var col = db.collection(plantsCollectionPath);
    var doc = await col.doc(plantId).get();
    if (!doc.exists) {
      return null;
    } else {
      return PlantModel._fromJson(doc.data()!);
    }
  }

  Future<void> store(FirebaseFirestore db) async {
    var doc = db.collection(plantsCollectionPath).doc(id);
    await doc.set(_toJson());
  }

  factory PlantModel._fromJson(Map<String, dynamic> data) {
    var imgLinks = data['imageLinks'];
    List<Uri>? imageLinks;
    if (imgLinks is Iterable) {
      imageLinks = List.from(imgLinks).map((e) => Uri.parse(e)).toList();
    }
    var tags = data['tags'];
    Map<String, String> tagsMap = {};
    if (tags is Map) {
      tagsMap = tags.map((key, value) => MapEntry(key, value as String));
    }
    return PlantModel(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      imageLinks: imageLinks!,
      tags: tagsMap,
    );
  }

  Map<String, dynamic> _toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageLinks': imageLinks.map((e) => e.toString()).toList(),
      'tags': tags,
    };
  }
}
