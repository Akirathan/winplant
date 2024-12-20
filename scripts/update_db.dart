import "dart:io";

import 'package:dotenv/dotenv.dart';
import 'package:xml/xml.dart';
import 'package:firedart/firedart.dart';
import 'package:http/http.dart' as http;

const plantProductCategory = '543558';
const plantProductType = 'Pokojové rostliny';

main() async {
  var env = DotEnv();
  env.load();
  var url = env['shoptetUrl']!;
  var response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    print('Failed to fetch the xml file: ${response}');
    exit(1);
  }
  Firestore.initialize('winplant-cba87');
  var fireStore = Firestore.instance;
  var plantsCollection = fireStore.collection('plants');
  var xmlDoc = XmlDocument.parse(response.body);
  var channel = xmlDoc.getElement('rss')!.getElement('channel')!;
  var items = channel.findElements('item');
  var updateTasks = <Future>[];
  for (var item in items) {
    var title = item.getElement('title')!.innerText;
    var normalizedTitle = normalizeName(title);
    // Id contains variants, for example '121/S', while `itemGroupId` does not - it should be just an integer
    var id = item.getElement('g:id')!.innerText;
    var itemGroupId = item.getElement('g:item_group_id')!.innerText;
    if (!isSinglePlantProduct(item)) {
      continue;
    }
    var description = item.getElement('description')!.innerText;
    var imageLinks = getImageLinks(item);
    var tags = getTags(item);
    print(
        'id: $id, itemGroupId: $itemGroupId, title: $title, normalizedTitle: $normalizedTitle');
    var doc = plantsCollection.document(itemGroupId);
    if (!await doc.exists) {
      var task = plantsCollection.document(itemGroupId).set({
        'id': itemGroupId,
        'title': title,
        'normalizedTitle': normalizedTitle,
        'description': description,
        'imageLinks': imageLinks.map((e) => e.toString()).toList(),
        'tags': tags,
      });
      updateTasks.add(task);
    }
  }
  print('Awaiting all futures (${updateTasks.length})');
  await Future.wait(updateTasks);
}

Map<String, String> getTags(XmlElement item) {
  var tags = <String, String>{};
  for (var productDetail in item.findAllElements("g:product_detail")) {
    var name = productDetail.getElement('g:attribute_name')!.innerText;
    var value = productDetail.getElement('g:attribute_value')!.innerText;
    tags[name] = value;
  }
  return tags;
}

bool isSinglePlantProduct(XmlElement item) {
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

String normalizeName(String name) {
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

List<Uri> getImageLinks(XmlElement item) {
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
