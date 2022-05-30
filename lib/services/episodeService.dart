import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_n_morty/models/episode.dart';

Future<List<Episode>> getEpisodesWithURL(List<String> episodeUrls) async {
  List<String> EpisodeIds = [];
  episodeUrls.forEach((url) {
    // EpisodeIds.add(url.substring(0, url.lastIndexOf('/')));
    EpisodeIds.add(url.substring(url.lastIndexOf('/')).split('/').last);
  });

  String Ids = EpisodeIds.join(',');
  final episodesResponse = await http
      .get(Uri.parse('https://rickandmortyapi.com/api/episode/${Ids}'));

  if (episodesResponse.statusCode == 200) {
    // final jsonResponse = json.decode(episodesResponse.body);
    List jsonResponse = jsonDecode(episodesResponse.body);
    // return jsonResponse.map((episode) => Episode.fromJson(episode)).toList();
    List<Episode> episodes =
        jsonResponse.map((x) => Episode.fromJson(x)).toList();
    return episodes;
    // return Episode.fromJson(jsonResponse);
    //  return List<Map<String, dynamic>>.from(json.decode(episodesResponse.body));
    //  return Episode.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load episodes');
  }
}
