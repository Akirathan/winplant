/// Information about plant as fetched from the catalogue.
class PlantModel {
  final String name;
  final String description;
  final List<Uri> imageLinks;
  final Map<String, String> tags;

  PlantModel({
    required this.name,
    required this.description,
    required this.imageLinks,
    required this.tags,
  });

  factory PlantModel.fromJson(Map<String, dynamic> data) {
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
      name: data['name'],
      description: data['description'],
      imageLinks: imageLinks!,
      tags: tagsMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageLinks': imageLinks.map((e) => e.toString()).toList(),
      'tags': tags,
    };
  }
}
