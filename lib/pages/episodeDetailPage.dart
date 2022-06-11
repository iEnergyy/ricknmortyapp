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

                    return builcCharactersGrid(characters);
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

  Widget builcCharactersGrid(List<Character> characters) => GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    shrinkWrap: true,
    children: List.generate(characters.length, (index) {
      return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          children: [
            Ink.image(
              image: NetworkImage(characters[index].image),
              height: double.infinity,
              fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: Text(
                  characters[index].name,
                  style:GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w700)),
                )
          ],
        ),
      );
    })
    );
}