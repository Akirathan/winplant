import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winplant/model/user_data.dart';

void main() {
  FirebaseFirestore db = FakeFirebaseFirestore();

  test('Test user data fetching', () async {
    var id = 'test-user';
    var userData = UserData(id: id, siteIds: []);
    await userData.store(db);
    var fetchedUserData = await UserData.fetch(db, id);
    expect(fetchedUserData!.id, id);
  });

  test('Fetch non-existing user', () async {
    var id = 'non-existing-user';
    var fetchedUserData = await UserData.fetch(db, id);
    expect(fetchedUserData, isNull);
  });

  tearDown(() async {});
}
