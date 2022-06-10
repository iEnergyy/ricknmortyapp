//TODO: Refactor.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/character.dart';
import '../models/episode.dart';
import '../services/episodeService.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.characterDetails}) : super(key: key);

  final Character characterDetails;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<List<Episode>>? episodesFuture;

  @override
  void initState() {
    episodesFuture = getEpisodesWithURL(widget.characterDetails.episode);
    super.initState();
  }

  Color getStatusColor() {
    switch (widget.characterDetails.status) {
      case 'Alive':
        return Colors.green;
      case 'Dead':
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Character Details',
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView(children: [
        Image.network(widget.characterDetails.image,
            width: double.infinity, height: 300, fit: BoxFit.cover),
        ListTile(
          title: Text(
            widget.characterDetails.name,
            textAlign: TextAlign.left,
            style:GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w700))),
        ListTile(
          leading: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  color: getStatusColor(),
                  borderRadius: BorderRadius.circular(100)),
            ),
          title: Text(
                '${widget.characterDetails.status} - ${widget.characterDetails.species}'),
          horizontalTitleGap: 0,
        ),
        ListTile(
          title: widget.characterDetails.type == ''
                  ? Text(widget.characterDetails.gender)
                  : Text('${widget.characterDetails.gender} - ${widget.characterDetails.type}')
        ),
        ListTile(
          title: Text(widget.characterDetails.origin.name),
        ),
        ExpansionTile(
          title: const Text('Episodes'),
          children: [
            FutureBuilder<List<Episode>>(
                future: episodesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(':( ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final episodes = snapshot.data!;

                    return buildEpisodes(episodes);
                  } else {
                    return const Text('No characters :(');
                  }
                })
          ],
          ),
        
      ]),
    );
  }

  Widget buildEpisodes(List<Episode> episodes) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];

        return Card(
          child: ListTile(
            title: Text(episode.name),
            subtitle: Text('${episode.episode} - ${episode.air_date}'),
          ),
        );
      });
}

