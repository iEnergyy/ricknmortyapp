
import 'package:flutter/material.dart';

import '../models/character.dart';
import '../services/characterService.dart';
import '../widgets/drawerNav.dart';
import 'characterDetailPage.dart';

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
        drawer: const DrawerNav(),
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