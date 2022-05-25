import 'dart:convert';

import '../models/character.dart';
import 'package:http/http.dart' as http;

Future<List<Character>> getCharacters() async {
  final response =
      await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['results'];
    return jsonResponse.map((data) => Character.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load characters');
  }
}
