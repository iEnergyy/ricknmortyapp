import 'package:flutter/material.dart';

import '../widgets/drawerNav.dart';

class EpisodeDetailPage extends StatefulWidget {
  const EpisodeDetailPage({Key? key}) : super(key: key);

  @override
  State<EpisodeDetailPage> createState() => _EpisodeDetailPageState();
}

class _EpisodeDetailPageState extends State<EpisodeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Episode'),
        ),
      drawer: const DrawerNav(),
    );
  }
}