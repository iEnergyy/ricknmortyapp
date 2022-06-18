import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/character.dart';
import '../models/location.dart';
import '../services/characterService.dart';

class LocationDetailPage extends StatefulWidget {
  const LocationDetailPage({Key? key, required this.locationDetails}) : super(key: key);
  final Location locationDetails;

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  Future<List<Character>>? residentsFuture;

  @override
  void initState() {
    residentsFuture = getCharactersWithURL(widget.locationDetails.residents);
    super.initState();
  }

  //TODO: make this page responsive.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Details'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
            widget.locationDetails.name,
            textAlign: TextAlign.left,
            style:GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w700))),
          ListTile(
            title: Text('Type: ${widget.locationDetails.type}'),
          ),
          ListTile(
            title: Text('Dimension: ${widget.locationDetails..dimension}'),
          ),
          ExpansionTile(
          title: const Text('Residents'),
          children: [
            FutureBuilder<List<Character>>(
                future: residentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(':( ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final residents = snapshot.data!;

                    return buildResidentsGrid(residents);
                  } else {
                    return const Text('No residents :(');
                  }
                })
          ],
          ),
        ],  
      ),
    );
  }

Widget buildResidentsGrid(List<Character> residents) => GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    shrinkWrap: true,
    children: List.generate(residents.length, (index) {
      return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: 
         Column(
           children: [
            Ink.image(
              image: NetworkImage(residents[index].image),
              height: 186,
              fit: BoxFit.cover,
              ),
            Align(
              alignment: const Alignment(-0.7, 1),
               child: Text(
               '${residents[index].name} - ${residents[index].species}',
               overflow: TextOverflow.ellipsis,
               style:GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black))
            ),
           ],
         ),
      );
    })
    );
}

