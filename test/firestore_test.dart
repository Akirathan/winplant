import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:winplant/model/garden_plant_model.dart';
import 'package:winplant/model/history.dart';
import 'package:winplant/model/plant_model.dart';
import 'package:winplant/model/site_model.dart';
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
      var id = 'timeline-gardenPlantId-1';
      var timeLine = _createTimeLine(id);
      await timeLine.store(db);
      var fetchedTimeLine = await TimeLine.fetch(db, id);
      expect(fetchedTimeLine, isNotNull);
      expect(fetchedTimeLine!.getEventsByTime().length, equals(4));
    });

    test('Store specific event', () async {
      try {
        var id = 'timeline-gardenPlantId-1';
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
      var timelineId = 'timeline-gardenPlantId-1';
      var timeLine = _createTimeLine(timelineId);
      await timeLine.store(db);
      var gardenPlant = GardenPlantModel(
          id: 'garden-plant-gardenPlantId-1',
          plantId: null,
          timelineId: timelineId);
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
          id: 'garden-plant-gardenPlantId-1', plantId: null, timelineId: 'FOO');
      await gardenPlant.store(db);
      var fetchedGardenPlant = await GardenPlantModel.fetch(db, gardenPlant.id);
      expect(fetchedGardenPlant, isNotNull);
      var fetchedTimeLine = await fetchedGardenPlant!.timeline(db);
      expect(fetchedTimeLine, isNull);
    });
  });

  group('Site data', () {
    test('Store and fetch site with garden plants', () async {
      var timelineId = 'timeline-id-1';
      var gardenPlantId = 'garden-plant-id-1';
      var siteId = 'site-id-1';
      var timeLine = _createTimeLine(timelineId);
      await timeLine.store(db);
      var gardenPlant = GardenPlantModel(
          id: gardenPlantId, plantId: null, timelineId: timelineId);
      await gardenPlant.store(db);
      var site = SiteModel(
          id: siteId, name: 'Obyvak', gardenPlantIds: [gardenPlant.id]);
      await site.store(db);
      var fetchedSite = await SiteModel.fetch(db, site.id);
      expect(fetchedSite, isNotNull);
      expect(fetchedSite!.gardenPlantIds.length, equals(1));
      var fetchedGardenPlant = await GardenPlantModel.fetch(db, gardenPlant.id);
      expect(fetchedGardenPlant, isNotNull);
      var fetchedTimeLine = await fetchedGardenPlant!.timeline(db);
      expect(fetchedTimeLine, isNotNull);
    });

    test('Site with non-existing garden plant', () async {
      var siteId = 'site-id-1';
      var site = SiteModel(id: siteId, name: 'Obyvak', gardenPlantIds: ['FOO']);
      await site.store(db);
      var fetchedSite = await SiteModel.fetch(db, site.id);
      expect(fetchedSite, isNotNull);
      var gardenPlants = fetchedSite!.gardenPlants(db);
      var gardenPlant = await gardenPlants.first;
      expect(gardenPlant, isNull);
    });
  });

  group('Plant data', () {
    test('Store and fetch plant', () async {
      var plantId = 'plant-id-1';
      var plant = PlantModel(
          id: plantId,
          name: 'Aloe Vera',
          description:
              'Aloe vera is a succulent plant species of the genus Aloe.',
          imageLinks: [
            Uri.parse(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Aloe_vera_flower_inset.png/220px-Aloe_vera_flower_inset.png')
          ],
          tags: {
            'Velikost': 'Velká',
            'Světlo': 'Slunce',
            'Voda': 'Málo',
          });
      await plant.store(db);
      var fetchedPlant = await PlantModel.fetch(db, plant.id);
      expect(fetchedPlant, isNotNull);
      expect(fetchedPlant!.name, equals(plant.name));
      expect(fetchedPlant.description, equals(plant.description));
      expect(fetchedPlant.imageLinks, equals(plant.imageLinks));
      expect(fetchedPlant.tags, equals(plant.tags));
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
