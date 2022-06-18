import 'package:flutter/material.dart';
import 'package:rick_n_morty/models/location.dart';
import 'package:rick_n_morty/pages/locationDetailPage.dart';
import 'package:rick_n_morty/services/locationService.dart';

import '../widgets/drawerNav.dart';

class LocationsLandingPage extends StatefulWidget {
  const LocationsLandingPage({Key? key}) : super(key: key);

  @override
  State<LocationsLandingPage> createState() => _LocationsLandingPageState();
}

class _LocationsLandingPageState extends State<LocationsLandingPage> {
  Future<List<Location>>? locationsFuture;
  
  @override
  void initState(){
    locationsFuture = getAllLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Locations'),
        ),
      drawer: const DrawerNav(),
      body: Center(
        child: FutureBuilder<List<Location>>(
          future: locationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(':( ${snapshot.error}');
            } else if (snapshot.hasData) {
              final locations = snapshot.data!;

              return buildLocations(locations);
            } else {
              return const Text('No characters :(');
            }
          },
        )
      ),
    );
  }
}

  Widget buildLocations(List<Location> locations) => ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];

          return Card(
            child: ListTile(
              title: Text(location.name),
              subtitle: Text(location.type),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => LocationDetailPage())));
              },
            ),
          );
        },
      );