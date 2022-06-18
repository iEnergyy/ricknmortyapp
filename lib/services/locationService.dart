import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_n_morty/models/location.dart';

Future<List<Location>> getAllLocations() async {
  List<Location> allLocations = [];
  final getPages =
      await http.get(Uri.parse('https://rickandmortyapi.com/api/location'));
  if (getPages.statusCode == 200) {
    int locationsPages = json.decode(getPages.body)['info']['pages'];
    for (int i = 1; i <= locationsPages; i++) {
      final response = await http.get(Uri.parse(
          'https://rickandmortyapi.com/api/location?page=${i.toString()}'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['results'];
        List<Location> locationsFromPage =
            jsonResponse.map((data) => Location.fromJson(data)).toList();
        allLocations.addAll(locationsFromPage);
      } else {
        throw Exception('Failed to load locations');
      }
    }
    return allLocations;
  } else {
    throw Exception('Failed to load locations');
  }
}

Future<Location> getLocation(int id) async {
  final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/location/${id.toString()}'));
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['results'];
    return jsonResponse.map((data) => Location.fromJson(data));
  } else {
    throw Exception('Failed to load location');
  }
}

Future<List<Location>> getLocationsWithURL(List<String> locationUrls) async {
  List<String> locationIds = [];
  for (var url in locationUrls) {
    locationIds.add(url.substring(url.lastIndexOf('/')).split('/').last);
  }

  String ids = locationIds.join(',');
  final locationsResponse = await http
      .get(Uri.parse('https://rickandmortyapi.com/api/episode/${ids}'));

  if (locationsResponse.statusCode == 200) {
    late List<Location> locations = [];
    if (locationUrls.length == 1) {
      Map<String, dynamic> jsonResponse = jsonDecode(locationsResponse.body);
      final location = jsonResponse;
      locations.add(Location.fromJson(location));
    } else {
      List jsonResponse = jsonDecode(locationsResponse.body);
      locations = jsonResponse.map((x) => Location.fromJson(x)).toList();
    }
    return locations;
  } else {
    throw Exception('Failed to load locations');
  }
}