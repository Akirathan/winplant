

import 'package:flutter/material.dart';
import 'package:winplant/model/history.dart';

class TimeLineWidget extends StatefulWidget {
  final TimeLine timeLine;

  const TimeLineWidget({super.key, required this.timeLine});

  @override
  State<StatefulWidget> createState() {
    return TimeLineWidgetState();
  }
}

class TimeLineWidgetState extends State<TimeLineWidget> {
  @override
  Widget build(BuildContext context) {
    var events = widget.timeLine.getEventsByTime();

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        var event = events[index];
        return _eventToWidget(event);
      },
    );
  }
}

Widget _eventToWidget(Event event) {
  switch (event) {
    case Fertilization fert:
      return _widget('Fertilization', fert.dateTime, const Icon(Icons.oil_barrel));
    case Watering watering:
      return _widget('Watering', watering.dateTime, const Icon(Icons.water_drop));
    case Note note:
      throw Exception('Unimplemented: $note');
    default:
      throw Exception('Unknown event type: $event');
  }
}

Widget _widget(String eventName, DateTime dateTime, Icon icon) {
  return ListTile(
    leading: icon,
    title: Text(eventName),
    subtitle: Text(dateTime.toString()),
  );
}
