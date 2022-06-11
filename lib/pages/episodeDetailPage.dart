import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rick_n_morty/models/character.dart';
import 'package:rick_n_morty/models/episode.dart';
import 'package:rick_n_morty/services/characterService.dart';

import '../widgets/drawerNav.dart';

class EpisodeDetailPage extends StatefulWidget {
  const EpisodeDetailPage({Key? key, required this.episodeDetails}) : super(key: key);
  final Episode episodeDetails;
  @override
  State<EpisodeDetailPage> createState() => _EpisodeDetailPageState();
}

class _EpisodeDetailPageState extends State<EpisodeDetailPage> {
  Future<List<Character>>? charactersFuture;

  @override
  void initState() {
    charactersFuture = getCharactersWithURL(widget.episodeDetails.characters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Episode Details'),
        ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
            widget.episodeDetails.name,
            textAlign: TextAlign.left,
            style:GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w700))),
          ListTile(
            title: Text('Air Date: ${widget.episodeDetails.air_date}'),
          ),
          ListTile(
            title: Text('Episode: ${widget.episodeDetails.episode}'),
          ),
          ListTile(
            title: Text('Created: ${widget.episodeDetails.created}'),
          ),
          ExpansionTile(
          title: const Text('Characters'),
          children: [
            FutureBuilder<List<Character>>(
                future: charactersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(':( ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final characters = snapshot.data!;

                    return buildCharacters(characters);
                  } else {
                    return const Text('No characters :(');
                  }
                })
          ],
          ),
        ],  
      ),
    );
  }

  Widget buildCharacters(List<Character> characters) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];

        return Card(
          child: ListTile(
            title: Text(character.name),
            subtitle: Text('${character.gender} - ${character.id}'),
          ),
        );
      });
}