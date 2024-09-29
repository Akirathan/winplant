import 'package:flutter/material.dart';
import 'package:winplant/model/history.dart';

class TimeLineWidget extends StatefulWidget {
  final TimeLine timeLine;

  const TimeLineWidget({super.key, required this.timeLine});

  @override
  State<StatefulWidget> createState() => TimeLineWidgetState();
}

class TimeLineWidgetState extends State<TimeLineWidget> {
  List<Event> _events = List.empty();
  bool _addingNote = false;

  @override
  void initState() {
    super.initState();
    _events = widget.timeLine.getEventsByTime().reversed.toList();
  }

  @override
  void dispose() {
    widget.timeLine.replaceAllEvents(_events);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: false,
      itemCount: _events.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _firstRow(context);
        }
        var eventIdx = index - 1;
        var event = _events.elementAt(eventIdx);
        var eventWidget = _eventToWidget(context, event, eventIdx);
        return Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: Colors.black)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: eventWidget);
      },
    );
  }

  /// First row allow users to add an event - it contains clickable icons.
  Widget _firstRow(BuildContext context) {
    if (!_addingNote) {
      return _headerConstantRow();
    } else {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Enter your note',
              icon: Icon(Icons.note),
            ),
            onSubmitted: (text) {
              setState(() {
                _events.insert(
                    0,
                    Note(
                      dateTime: DateTime.now(),
                      note: text,
                    ));
                _addingNote = false;
              });
            },
          ));
    }
  }

  /// First row with three buttons to add events
  Padding _headerConstantRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
              backgroundColor: Colors.blue.shade300,
              icon: const Icon(Icons.water_drop),
              label: const Text('Watering'),
              onPressed: () {
                setState(() {
                  _events.insert(0, Watering(dateTime: DateTime.now()));
                });
              }),
          FloatingActionButton.extended(
              backgroundColor: Colors.orange.shade400,
              icon: const Icon(Icons.oil_barrel),
              label: const Text('Fertilization'),
              onPressed: () {
                setState(() {
                  _events.insert(0, Fertilization(dateTime: DateTime.now()));
                });
              }),
          FloatingActionButton.extended(
              label: const Text('Note'),
              icon: const Icon(Icons.note),
              onPressed: () {
                setState(() {
                  _addingNote = true;
                });
              })
        ],
      ),
    );
  }

  Widget _eventToWidget(BuildContext context, Event event, int eventIdx) {
    switch (event) {
      case Watering watering:
        return _widget(Icon(Icons.water_drop, color: Colors.blue.shade300),
            'Watering', watering.dateTime, eventIdx);
      case Fertilization fert:
        return _widget(Icon(Icons.oil_barrel, color: Colors.orange.shade400),
            'Fertilization', fert.dateTime, eventIdx);
      case Note note:
        return _widget(Icon(Icons.note, color: Colors.grey.shade600), note.note,
            note.dateTime, eventIdx);
      default:
        throw Exception('Unknown event type: $event');
    }
  }

  Widget _wateringEvent(Watering watering, int eventIdx) {
    return _widget(Icon(Icons.water_drop, color: Colors.blue.shade300),
        'Watering', watering.dateTime, eventIdx);
  }

  Widget _dateTime(DateTime dateTime) {
    var date = '${dateTime.day}.${dateTime.month}.${dateTime.year}';
    // Format date in 00:10 format
    var hour = dateTime.hour.toString().padLeft(2, '0');
    var minute = dateTime.minute.toString().padLeft(2, '0');
    var time = '$hour:$minute';
    return Column(children: [Text(date), Text(time)]);
  }

  Widget _widget(Icon icon, String eventName, DateTime dateTime, int eventIdx) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      icon,
      Text(eventName),
      _dateTime(dateTime),
      Padding(
        padding: const EdgeInsets.only(left: 15, top: 9, bottom: 9),
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          tooltip: 'Delete',
          backgroundColor: Colors.pink.shade100,
          mini: true,
          onPressed: () {
            setState(() {
              _events.removeAt(eventIdx);
            });
          },
          child: const Icon(Icons.delete, size: 20),
        ),
      ),
    ]);
  }
}
