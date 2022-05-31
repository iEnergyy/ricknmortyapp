import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_n_morty/models/episode.dart';

Future<List<Episode>> getEpisodesWithURL(List<String> episodeUrls) async {
  List<String> wpisodeIds = [];
  for (var url in episodeUrls) {
    wpisodeIds.add(url.substring(url.lastIndexOf('/')).split('/').last);
  }

  String ids = wpisodeIds.join(',');
  final episodesResponse = await http
      .get(Uri.parse('https://rickandmortyapi.com/api/episode/${ids}'));

  if (episodesResponse.statusCode == 200) {
    late List<Episode> episodes = [];
    if (episodeUrls.length == 1) {
      Map<String, dynamic> jsonResponse = jsonDecode(episodesResponse.body);
      final episode = jsonResponse;
      episodes.add(Episode.fromJson(episode));
    } else {
      List jsonResponse = jsonDecode(episodesResponse.body);
      episodes = jsonResponse.map((x) => Episode.fromJson(x)).toList();
    }
    return episodes;
  } else {
    throw Exception('Failed to load episodes');
  }
}
