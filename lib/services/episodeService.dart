import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_n_morty/models/episode.dart';

Future<List<Episode>> getEpisodesWithURL(List<String> episodeUrls) async {
  List<String> EpisodeIds = [];
  episodeUrls.forEach((url) {
    EpisodeIds.add(url.substring(url.lastIndexOf('/')).split('/').last);
  });

  String Ids = EpisodeIds.join(',');
  final episodesResponse = await http
      .get(Uri.parse('https://rickandmortyapi.com/api/episode/${Ids}'));

  if (episodesResponse.statusCode == 200) {
    late List<Episode> episodes = [];
    if (episodeUrls.length == 1) {
      // List<Episode> episode = jsonResponse.cast<Episode>().toList();
      Map<String, dynamic> jsonResponse =
          jsonDecode(episodesResponse.body); //good
      // episodes.add(episode[0]);
      // final episode = jsonResponse as Map<String, dynamic>;
      final episode = jsonResponse;
      // episodes.add(Episode.fromJson(episode));
      episodes.add(Episode.fromJson(episode));
    } else {
      List jsonResponse = jsonDecode(episodesResponse.body); //good
      episodes = jsonResponse.map((x) => Episode.fromJson(x)).toList();
    }

    // List<Episode> episodes2 = episodeUrls.length > 1
    //     ? jsonResponse.cast<Episode>().toList()
    //     : jsonResponse.map((x) => Episode.fromJson(x)).toList();

    // List<Episode> episodes =
    //     jsonResponse.map((x) => Episode.fromJson(x)).toList();
    return episodes;
    // return episodes2;
  } else {
    throw Exception('Failed to load episodes');
  }
}
