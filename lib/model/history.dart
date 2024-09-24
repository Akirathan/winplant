

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
  /// Ordered by time
  final List<Event> _events = List.empty(growable: true);

  void addEvent(Event event) {
    _events.add(event);
  }

  List<Event> getEventsByTime() {
    return _events;
  }
}
