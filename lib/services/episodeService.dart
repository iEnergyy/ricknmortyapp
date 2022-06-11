import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_n_morty/models/episode.dart';

Future<List<Episode>> getEpisodesWithURL(List<String> episodeUrls) async {
  List<String> episodeIds = [];
  for (var url in episodeUrls) {
    episodeIds.add(url.substring(url.lastIndexOf('/')).split('/').last);
  }

  String ids = episodeIds.join(',');
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

Future<List<Episode>> getAllEpisodes() async {
  List<Episode> AllEpisodes = [];
  final getPages =
      await http.get(Uri.parse('https://rickandmortyapi.com/api/episode'));
  if (getPages.statusCode == 200) {
    int episodesPages = json.decode(getPages.body)['info']['pages'];
    for (int i = 1; i <= episodesPages; i++) {
      final response = await http.get(Uri.parse(
          'https://rickandmortyapi.com/api/episode?page=${i.toString()}'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['results'];
        List<Episode> episodessFromPage =
            jsonResponse.map((data) => Episode.fromJson(data)).toList();
        AllEpisodes.addAll(episodessFromPage);
      } else {
        throw Exception('Failed to load episodes');
      }
    }
    return AllEpisodes;
  } else {
    throw Exception('Failed to load episodes');
  }
}

Future<Episode> getEpisode(int id) async {
  final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/episode/${id.toString()}'));
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['results'];
    return jsonResponse.map((data) => Episode.fromJson(data));
  } else {
    throw Exception('Failed to load episode');
  }
}