import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winplant/model/garden_plant_model.dart';
import 'package:winplant/model/history.dart';
import 'package:winplant/model/user_data.dart';

void main() {
  var db = FakeFirebaseFirestore();

  setUp(() async {
    await db.clearPersistence();
  });

  group('User data', () {
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
  });

  group('History data', () {
    test('Timeline store', () async {
      var id = 'timeline-id-1';
      var timeLine = _createTimeLine(id);
      await timeLine.store(db);
      var fetchedTimeLine = await TimeLine.fetch(db, id);
      expect(fetchedTimeLine, isNotNull);
      expect(fetchedTimeLine!.getEventsByTime().length, equals(4));
    });

    test('Store specific event', () async {
      try {
        var id = 'timeline-id-1';
        var dateTime = DateTime.parse('2024-09-01');
        var timeLine = TimeLine(id: id);
        timeLine.addEvent(Watering(dateTime: dateTime));
        await timeLine.store(db);
        var fetchedTimeLine = await TimeLine.fetch(db, id);
        expect(fetchedTimeLine, isNotNull);
        expect(fetchedTimeLine!.getEventsByTime().length, equals(1));
        var fetchedEvent = fetchedTimeLine.getEventsByTime().first;
        expect(fetchedEvent, isA<Watering>());
        expect(fetchedEvent.dateTime, equals(dateTime));
      } on TestFailure catch (e) {
        print('Test failed: $e');
        print(db.dump());
        rethrow;
      }
    });

    test('Fetch non-existing', () async {
      var id = 'non-existing-timeline';
      var fetchedTimeLine = await TimeLine.fetch(db, id);
      expect(fetchedTimeLine, isNull);
    });
  });

  group('Garden Plants data', () {
    test('Store and fetch garden plant with timeline', () async {
      var timelineId = 'timeline-id-1';
      var timeLine = _createTimeLine(timelineId);
      await timeLine.store(db);
      var gardenPlant = GardenPlantModel(
          id: 'garden-plant-id-1', plantId: null, timelineId: timelineId);
      gardenPlant.store(db);
      var fetchedTimeLine = await gardenPlant.timeline(db);
      expect(fetchedTimeLine, isNotNull);
      expect(fetchedTimeLine!.getEventsByTime().length, equals(4));
      var fetchedGardenPlant = await GardenPlantModel.fetch(db, gardenPlant.id);
      expect(fetchedGardenPlant, isNotNull);
      expect(fetchedGardenPlant!.timelineId, equals(timelineId));
    });

    test('Fetch non-existing timeline', () async {
      var gardenPlant = GardenPlantModel(
          id: 'garden-plant-id-1', plantId: null, timelineId: 'FOO');
      await gardenPlant.store(db);
      var fetchedGardenPlant = await GardenPlantModel.fetch(db, gardenPlant.id);
      expect(fetchedGardenPlant, isNotNull);
      var fetchedTimeLine = await fetchedGardenPlant!.timeline(db);
      expect(fetchedTimeLine, isNull);
    });
  });
}

TimeLine _createTimeLine(String id) {
  var timeLine = TimeLine(id: id);
  timeLine.addEvent(Watering(dateTime: DateTime.parse('2024-09-01')));
  timeLine.addEvent(Fertilization(dateTime: DateTime.parse('2024-09-03')));
  timeLine.addEvent(Note(
      dateTime: DateTime.parse('2024-09-10'),
      note: 'To mi to ale pekne roste!'));
  timeLine.addEvent(Watering(dateTime: DateTime.parse('2024-09-12')));
  return timeLine;
}
