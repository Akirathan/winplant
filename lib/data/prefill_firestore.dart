import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winplant/model/garden_plant_model.dart';
import 'package:winplant/model/history.dart';
import 'package:winplant/model/site_model.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:io';
import 'package:winplant/model/plant_model.dart';

const plantProductCategory = '543558';
const plantProductType = 'Pokojové rostliny';
const plantsCollectionPath = 'plants';
const usersCollectionPath = 'users';

initPlants(FirebaseFirestore db, Uri shoptetUri) async {
  var response = await http.get(shoptetUri);
  if (response.statusCode != 200) {
    print('Failed to fetch the xml file: ${response}');
    exit(1);
  }
  var xmlDoc = XmlDocument.parse(response.body);
  var channel = xmlDoc.getElement('rss')!.getElement('channel')!;
  var items = channel.findElements('item');
  var updateTasks = <Future>[];
  for (var item in items) {
    var title = item.getElement('title')!.innerText;
    var normalizedTitle = _normalizeName(title);
    // Id contains variants, for example '121/S', while `itemGroupId` does not - it should be just an integer
    var id = item.getElement('g:id')!.innerText;
    var itemGroupId = item.getElement('g:item_group_id')!.innerText;
    if (!_isSinglePlantProduct(item)) {
      continue;
    }
    var description = item.getElement('description')!.innerText;
    var imageLinks = _getImageLinks(item);
    var tags = _getTags(item);
    var plantModel = PlantModel(
      id: itemGroupId,
      name: title,
      description: description,
      imageLinks: imageLinks,
      tags: tags,
    );
    var uploadPlantTask = _uploadPlant(db, plantModel);
    updateTasks.add(uploadPlantTask);
  }
  if (updateTasks.isNotEmpty) {
    developer.log('Awaiting all futures (${updateTasks.length})',
        name: 'prefill');
    return Future.wait(updateTasks);
  }
}

/// Initializes all the dummy sites and garden plants for the logged-in user.
///
/// [userId] is the Firebase Auth user ID for a logged in dummy user.
initUserData(FirebaseFirestore db, String userId) async {
  developer.log('Initializing user data for $userId', name: 'prefill');
  var timeLine = TimeLine(id: 'timeline-id-1');
  timeLine.addEvent(Watering(dateTime: DateTime.parse('2024-09-01')));
  timeLine.addEvent(Fertilization(dateTime: DateTime.parse('2024-09-03')));
  timeLine.addEvent(Note(
      dateTime: DateTime.parse('2024-09-10'),
      note: 'To mi to ale pekne roste!'));
  timeLine.addEvent(Watering(dateTime: DateTime.parse('2024-09-12')));
  await timeLine.store(db);
  var gardenPlant = GardenPlantModel(
      id: 'garden-plant-id-1', plantId: '103', timelineId: 'timeline-id-1');
  await gardenPlant.store(db);
  var fetchedTimeline = await gardenPlant.timeline(db);
  assert(fetchedTimeline!.id == timeLine.id);

  var site = SiteModel(
      id: 'site-id-1', name: 'Obyvak', gardenPlantIds: ['garden-plant-id-1']);
  await site.store(db);
  developer.log('User data initialized for $userId', name: 'prefill');
}

Future<void> _uploadPlant(FirebaseFirestore db, PlantModel plant) async {
  var fetchedPlant = await PlantModel.fetch(db, plant.id);
  if (fetchedPlant == null) {
    developer.log('Uploading plant ${plant.name}', name: 'prefill');
    await plant.store(db);
  }
}

Map<String, String> _getTags(XmlElement item) {
  var tags = <String, String>{};
  for (var productDetail in item.findAllElements("g:product_detail")) {
    var name = productDetail.getElement('g:attribute_name')!.innerText;
    var value = productDetail.getElement('g:attribute_value')!.innerText;
    tags[name] = value;
  }
  return tags;
}

bool _isSinglePlantProduct(XmlElement item) {
  var productCategory = item.getElement('g:google_product_category')?.innerText;
  var productType = item.getElement('g:product_type')?.innerText;
  if (productCategory != null && productType != null) {
    return productCategory == plantProductCategory &&
        (productType.contains(plantProductType) &&
            !productType.contains("Set"));
  } else {
    return false;
  }
}

String _normalizeName(String name) {
  var normalizedName = name
      .toLowerCase()
      .replaceAll(" ", "-")
      .replaceAll(":", "-")
      .replaceAll("(", "")
      .replaceAll(")", "")
      .replaceAll("'", "")
      .replaceAll('"', "");
  // Remove all non-ascii characters
  normalizedName = normalizedName.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
  // Remove consecutive dashes
  normalizedName = normalizedName.replaceAll(RegExp(r'-+'), '-');
  return normalizedName;
}

List<Uri> _getImageLinks(XmlElement item) {
  var allLinks = <Uri>[];
  var imageLink = item.getElement('g:image_link');
  if (imageLink != null) {
    allLinks.add(Uri.parse(imageLink.innerText));
  }
  var additionalImageLink = item.getElement('g:additional_image_link');
  if (additionalImageLink != null) {
    allLinks.add(Uri.parse(additionalImageLink.innerText));
  }
  return allLinks;
}
