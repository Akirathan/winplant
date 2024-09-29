

import 'package:flutter/material.dart';
import 'package:winplant/model/plant.dart';
import 'package:winplant/widgets/history_widget.dart';
import 'package:winplant/widgets/plant_info_widget.dart';

/// A widget for a plant in the garden.
class PlantWidget extends StatefulWidget {
  final Plant plant;

  const PlantWidget({super.key, required this.plant});

  @override
  State<PlantWidget> createState() => _PlantWidgetState();
}

class _PlantWidgetState extends State<PlantWidget> {
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.plant.name ?? widget.plant.info.name;
  }

  @override
  void dispose() {
    widget.plant.name = _name;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var img = widget.plant.image ?? widget.plant.info.image;
    var tabs = const [
      Tab(
        icon: Icon(Icons.history),
        text: 'Time Line'
      ),
      Tab(
        icon: Icon(Icons.edit),
        text: 'Edit'
      ),
      Tab(
        icon: Icon(Icons.description),
        text: 'Description'
      )
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_name),
          bottom: TabBar(
            tabs: tabs
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 2, child: Image(image: img)),
            Flexible(child: Text(_name, style: const TextStyle(fontSize: 20))),
            Expanded(
              flex: 7,
              child: TabBarView(
                children: [
                  TimeLineWidget(timeLine: widget.plant.timeLine),
                  _editTab(context),
                  PlantInfoWidget(plant: widget.plant.info)
                ],
              )
            )
          ]
        ),
      ),
    );
  }

  Widget _editTab(BuildContext context) {
    var textField = TextField(
      decoration: const InputDecoration(
        labelText: 'Plant name',
        hintText: 'Enter a new name',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38)
        ),
        icon: Icon(Icons.edit),
      ),
      onSubmitted: (String text) {
        setState(() {
          _name = text;
        });
      },
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: textField
          )
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: OutlinedButton.icon(
              onPressed: () {
                throw UnimplementedError('Change Image');
              },
              icon: const Icon(Icons.image),
              label: const Text('Change Image'),
            ),
          ),
        )
      ]
    );
  }
}
