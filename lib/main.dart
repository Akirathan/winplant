import 'package:flutter/material.dart';
import 'package:winplant/routes.dart';
import 'package:winplant/widgets/dashboard.dart';
import 'package:winplant/widgets/plant_catalogue_widget.dart';
import 'package:winplant/widgets/garden_widget.dart';


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
      onGenerateRoute: (RouteSettings settings) => generateRoute(settings)
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
    var garden = const GardenWidget();
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
            label: 'Garden',
          ),
        ],
        onDestinationSelected: (int idx) {
          setState(() {
            _currPageIdx = idx;
          });
        },
        selectedIndex: _currPageIdx,
      ),
      body: <Widget>[dashBoard, plantCatalogue, garden][_currPageIdx],
    );
  }
}
