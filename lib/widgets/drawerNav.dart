import 'package:flutter/material.dart';

import '../pages/episodesLandingPage.dart';
import '../pages/homePage.dart';
import '../pages/locationsLandingPage.dart';

class DrawerNav extends StatefulWidget {
  const DrawerNav({Key? key}) : super(key: key);

  @override
  State<DrawerNav> createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/ricknmortyheader.jpg'),
                    ),
                  color: Colors.blue
                  ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: const Text('Rick and Morty by Maiguel'),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.accessibility),
              title: const Text('Characters'),
              onTap: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const HomePage(title: 'Characters',))));
              },
            ),
            ListTile(
              leading: const Icon(Icons.ondemand_video),
              title: const Text('Episodes'),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const EpisodesLandingPage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Locations'),
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const LocationsLandingPage())));
              },
            ),
            ],
          ),
    );
  }
}