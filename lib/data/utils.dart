import 'package:cloud_firestore/cloud_firestore.dart';

typedef DocRef = DocumentReference<Map<String, dynamic>>;

Future<bool> docExists(DocumentReference<Map<String, dynamic>> docRef) async {
  var doc = await docRef.get();
  return doc.exists;
}

List<String> asStrList(dynamic data) {
  return (data as List<dynamic>).map((it) => it.toString()).toList();
}
