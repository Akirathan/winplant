import 'package:flutter/material.dart';
import 'package:winplant/model/plant_catalogue.dart';
import 'package:winplant/widgets/plant_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: DefaultTextStyle(
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
            ),
            child: FutureBuilder(
                future: PlantCatalogue.monsteraStadleyana(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    var plant = snapshot.data;
                    return PlantWidget(plant: plant!);
                  }
                })));
  }
}
