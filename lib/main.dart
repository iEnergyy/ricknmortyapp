import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

//TODO: Create a cool UI for the detail page.
//TODO: Refactor.
class DetailPage extends StatelessWidget {
  const DetailPage({Key? key, required this.characterDetails})
      : super(key: key);

  final Character characterDetails;
  Color getStatusColor() {
    switch (characterDetails.status) {
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
        Image.network(characterDetails.image,
            width: double.infinity, height: 300, fit: BoxFit.cover),
        Text(characterDetails.name,
            textAlign: TextAlign.left,
            style:
                GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w700)),
        Row(
          children: [
            Container(
              height: 15,
              width: 15,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                  color: getStatusColor(),
                  borderRadius: BorderRadius.circular(100)),
            ),
            Text('${characterDetails.status} - ${characterDetails.species}',
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                    fontSize: 15, fontWeight: FontWeight.w400)),
          ],
        ),
        Text(characterDetails.gender),
        Text(characterDetails.origin.name),
        Text(characterDetails.episode.first),
      ]),
    );
  }
}
// class DetailPage extends StatelessWidget {
//   const DetailPage({Key? key, required this.characterDetails})
//       : super(key: key);

//   final Character characterDetails;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(characterDetails.name),
//         ),
//         body: ListView(
//           children: <Widget>[
//             Image.network(characterDetails.image),
//             Text('Name: ${characterDetails.name}'),
//             Text('Gender: ${characterDetails.gender}'),
//             Text(
//                 'Status: ${characterDetails.status} - ${characterDetails.species}'),
//             Text('Origin name: ${characterDetails.origin.name}'),
//           ],
//         ));
//   }
// }
