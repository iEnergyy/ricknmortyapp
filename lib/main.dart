import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rick_n_morty/models/episode.dart';
import 'package:rick_n_morty/services/episodeService.dart';

import 'models/character.dart';
import 'services/characterService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick And Morty App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Rick And Morty'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Character>>? charactersFuture;

  @override
  void initState() {
    charactersFuture = getCharacters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: (){},
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: (){},
            )
            ],
          ),
        ),
        body: Center(
            child: FutureBuilder<List<Character>>(
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
          },
        )));
  }

  Widget buildCharacters(List<Character> characters) => ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(character.image),
              ),
              title: Text(character.name),
              subtitle: Text(character.species),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => DetailPage(
                              characterDetails: character,
                            ))));
              },
            ),
          );
        },
      );
}

//TODO: Refactor.
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

