import 'dart:convert';

import '../models/character.dart';
import 'package:http/http.dart' as http;

Future<List<Character>> getCharacters() async {
  List<Character> AllCharacters = [];
  final getPages =
      await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
  if (getPages.statusCode == 200) {
    int charactersPages = json.decode(getPages.body)['info']['pages'];
    for (int i = 1; i <= charactersPages; i++) {
      final response = await http.get(Uri.parse(
          'https://rickandmortyapi.com/api/character?page=${i.toString()}'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['results'];
        List<Character> charactersFromPage =
            jsonResponse.map((data) => Character.fromJson(data)).toList();
        AllCharacters.addAll(charactersFromPage);
      } else {
        throw Exception('Failed to load characters');
      }
    }
    return AllCharacters;
  } else {
    throw Exception('Failed to load characters');
  }
}

Future<Character> getCharacter(int id) async {
  final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character/${id.toString()}'));
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['results'];
    return jsonResponse.map((data) => Character.fromJson(data));
  } else {
    throw Exception('Failed to load character');
  }
}

Future<List<Character>> getCharactersWithURL(List<String> characterUrls) async {
  List<String> characterIds = [];
  for (var url in characterUrls) {
    characterIds.add(url.substring(url.lastIndexOf('/')).split('/').last);
  }

  String ids = characterIds.join(',');
  final charactersResponse = await http
      .get(Uri.parse('https://rickandmortyapi.com/api/character/${ids}'));

  if (charactersResponse.statusCode == 200) {
    late List<Character> characters = [];
    if (characterUrls.length == 1) {
      Map<String, dynamic> jsonResponse = jsonDecode(charactersResponse.body);
      final character = jsonResponse;
      characters.add(Character.fromJson(character));
    } else {
      List jsonResponse = jsonDecode(charactersResponse.body);
      characters = jsonResponse.map((x) => Character.fromJson(x)).toList();
    }
    return characters;
  } else {
    throw Exception('Failed to load characters');
  }
}