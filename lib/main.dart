import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:winplant/routes.dart';
import 'package:winplant/widgets/dashboard.dart';
import 'package:winplant/data/prefill_firestore.dart';
import 'package:winplant/widgets/plant_catalogue_widget.dart';
import 'package:winplant/widgets/garden_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // If Flutter is run in development mode
  if (!kReleaseMode) {
    await _initEmulators();
  } else {
    throw UnsupportedError(
        'Firestore emulator is only supported in development mode');
  }
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
        onGenerateRoute: (RouteSettings settings) => generateRoute(settings));
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

_initEmulators() async {
  log('Prefilling Firestore with dummy data', name: 'prefill');
  FirebaseFirestore.instance.useFirestoreEmulator("127.0.0.1", 8080);
  var db = FirebaseFirestore.instance;
  await dotenv.load();
  var shoptetUri = Uri.parse(dotenv.env['shoptetUrl']!);
  await initPlants(db, shoptetUri);
  // Init auth emulator
  var auth = FirebaseAuth.instance;
  await auth.useAuthEmulator('127.0.0.1', 9099);
  var userEmail = 'dummy@dummy.org';
  var userPwd = '123456';
  User user;
  try {
    var signedIn = await auth.signInWithEmailAndPassword(
        email: userEmail, password: userPwd);
    user = signedIn.user!;
  } on FirebaseException {
    // The account is not yet created
    var userCredential = await auth.createUserWithEmailAndPassword(
        email: userEmail, password: userPwd);
    user = userCredential.user!;
    log('Created user $user', name: 'prefill');
  }
  var userId = user.uid;
  log('User logged: $userId', name: 'prefill');
  assert(auth.currentUser != null);
  await initUserData(db, userId);
  log('All emulators initialized and prefilled', name: 'prefill');
}
