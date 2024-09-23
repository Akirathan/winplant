import 'package:flutter/material.dart';
import 'package:winplant/widgets/dashboard.dart';
import 'package:winplant/widgets/plant_catalogue_widget.dart';
import 'package:winplant/widgets/plant_widget.dart';
import 'package:winplant/widgets/site_list_widget.dart';
import 'package:winplant/widgets/site_preview_widget.dart';
import 'package:winplant/model/dummy_data.dart' as dummy;
import 'package:winplant/widgets/site_widget.dart';

import 'model/plant.dart';
import 'model/site.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Win Plant',
      theme: ThemeData(useMaterial3: true),
      home: const _MainScaffold(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/plant') {
          var plant = settings.arguments as Plant;
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(plant.name),
              ),
                body: PlantWidget(plant: plant)
            ),
          );
        } else if (settings.name == '/site') {
          var site = settings.arguments as Site;
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(site.name),
              ),
              body: SiteWidget(site: site),
            ),
          );
        }
        return null;
      },
    );
  }
}

class _MainScaffold extends StatefulWidget {
  const _MainScaffold();

  @override
  State<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<_MainScaffold> {
  int _currPageIdx = 0;

  @override
  Widget build(BuildContext context) {
    var dashBoard = const DashBoard();
    var plantCatalogue = const PlantCatalogueWidget();
    var siteList = const SiteListWidget();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Win Plant'),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Plant Catalogue',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Site List',
          ),
        ],
        onDestinationSelected: (int idx) {
          setState(() {
            _currPageIdx = idx;
          });
        },
        selectedIndex: _currPageIdx,
      ),
      body: <Widget>[dashBoard, plantCatalogue, siteList][_currPageIdx],
    );
  }
}
