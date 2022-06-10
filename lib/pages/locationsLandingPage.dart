import 'package:flutter/material.dart';

import '../widgets/drawerNav.dart';

class LocationsLandingPage extends StatefulWidget {
  const LocationsLandingPage({Key? key}) : super(key: key);

  @override
  State<LocationsLandingPage> createState() => _LocationsLandingPageState();
}

class _LocationsLandingPageState extends State<LocationsLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Locations'),
        ),
      drawer: const DrawerNav(),
    );
  }
}