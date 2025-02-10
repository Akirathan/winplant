import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

const timelinePath = 'timeline';

/// `/timeline/<timelineId>/events`
const eventsPath = 'events';

/// Historical event for a plant.
abstract class Event {
  final DateTime dateTime;

  Event({required this.dateTime});
}

class Fertilization extends Event {
  Fertilization({required super.dateTime});
}

class Watering extends Event {
  Watering({required super.dateTime});
}

/// A note can be added as a historical event.
class Note extends Event {
  final String note;

  Note({required super.dateTime, required this.note});
}

class TimeLine {
  final String id;

  /// Ordered by time
  final List<Event> _events = List.empty(growable: true);

  TimeLine({required this.id});

  static Future<TimeLine?> fetch(
      FirebaseFirestore db, String timelineId) async {
    log('Fetching timeline $timelineId');
    var eventsCol = await db
        .collection(timelinePath)
        .doc(timelineId)
        .collection(eventsPath)
        .get();
    if (eventsCol.size == 0) {
      return null;
    } else {
      var timeline = TimeLine(id: timelineId);
      for (var eventDoc in eventsCol.docs) {
        var eventData = eventDoc.data();
        var event = _eventFromJson(eventData);
        timeline.addEvent(event);
      }
      return timeline;
    }
  }

  Future<void> store(FirebaseFirestore db) async {
    log('Storing timeline $id');
    var timelineDoc = db.collection(timelinePath).doc(id);
    if ((await timelineDoc.get()).exists) {
      log('Deleting existing events for timeline $id');
      await timelineDoc.delete();
    }
    var eventsCol = timelineDoc.collection(eventsPath);
    for (var event in getEventsByTime()) {
      var eventData = _eventToJson(event);
      await eventsCol.doc().set(eventData);
    }
  }

  void addEvent(Event event) {
    _events.add(event);
  }

  List<Event> getEventsByTime() {
    return _events;
  }

  void replaceAllEvents(List<Event> events) {
    _events.clear();
    _events.addAll(events);
  }
}

Event _eventFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'fertilization':
      return Fertilization(dateTime: DateTime.parse(json['dateTime']));
    case 'watering':
      return Watering(dateTime: DateTime.parse(json['dateTime']));
    case 'note':
      return Note(
          dateTime: DateTime.parse(json['dateTime']), note: json['note']);
    default:
      throw ArgumentError('Unknown event type: ${json['type']}');
  }
}

Map<String, dynamic> _eventToJson(Event event) {
  if (event is Fertilization) {
    return {
      'type': 'fertilization',
      'dateTime': event.dateTime.toIso8601String()
    };
  } else if (event is Watering) {
    return {'type': 'watering', 'dateTime': event.dateTime.toIso8601String()};
  } else if (event is Note) {
    return {
      'type': 'note',
      'dateTime': event.dateTime.toIso8601String(),
      'note': event.note
    };
  } else {
    throw ArgumentError('Unknown event type: $event');
  }
}
