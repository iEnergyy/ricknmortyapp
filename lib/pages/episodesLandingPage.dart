import 'package:flutter/material.dart';
import 'package:rick_n_morty/pages/episodeDetailPage.dart';
import 'package:rick_n_morty/services/episodeService.dart';

import '../models/episode.dart';
import '../widgets/drawerNav.dart';

class EpisodesLandingPage extends StatefulWidget {
  const EpisodesLandingPage({Key? key}) : super(key: key);

  @override
  State<EpisodesLandingPage> createState() => _EpisodesLandingPageState();
}

class _EpisodesLandingPageState extends State<EpisodesLandingPage> {

Future<List<Episode>>? episodesFuture;

  @override
  void initState() {
    episodesFuture = getAllEpisodes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Episodes'),
        ),
        drawer: const DrawerNav(),
        body: Center(
            child: FutureBuilder<List<Episode>>(
          future: episodesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(':( ${snapshot.error}');
            } else if (snapshot.hasData) {
              final characters = snapshot.data!;

              return buildEpisodes(characters);
            } else {
              return const Text('No characters :(');
            }
          },
        )));
  }
}
  Widget buildEpisodes(List<Episode> episodes) => ListView.builder(
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          final episode = episodes[index];

          return Card(
            child: ListTile(
              title: Text(episode.name),
              subtitle: Text(episode.episode),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => EpisodeDetailPage(
                          episodeDetails: episode,
                        ))));
              },
            ),
          );
        },
      );
