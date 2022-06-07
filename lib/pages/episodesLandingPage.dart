import 'package:flutter/material.dart';

import '../widgets/drawerNav.dart';

class EpisodesLandingPage extends StatefulWidget {
  const EpisodesLandingPage({Key? key}) : super(key: key);

  @override
  State<EpisodesLandingPage> createState() => _EpisodesLandingPageState();
}

class _EpisodesLandingPageState extends State<EpisodesLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Episodes'),
        ),
      drawer: const DrawerNav(),
    );
  }
}