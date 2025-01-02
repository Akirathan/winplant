import 'package:cloud_firestore/cloud_firestore.dart';
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
    var uploadPlantTask = _uploadPlant(plantModel);
    updateTasks.add(uploadPlantTask);
  }
  if (updateTasks.isNotEmpty) {
    developer.log('Awaiting all futures (${updateTasks.length})',
        name: 'prefill');
    await Future.wait(updateTasks);
    developer.log('All futures completed', name: 'prefill');
  }
}

Future<void> _uploadPlant(PlantModel plant) async {
  var fetchedPlant = await fetchPlant(plant.id);
  if (fetchedPlant == null) {
    developer.log('Uploading plant ${plant.name}', name: 'prefill');
    await storePlant(plant);
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
