// ignore_for_file: non_constant_identifier_names

class Episode {
  late int id;
  late String name;
  late String air_date;
  late String episode;
  late List<String> characters;
  late String url;
  late String created;

  Episode({
    required this.id,
    required this.name,
    required this.air_date,
    required this.characters,
    required this.url,
    required this.created,
  });

  Episode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    air_date = json['air_date'];
    episode = json['episode'];
    characters = json['characters'].cast<String>();
    url = json['url'];
    created = json['created'];
  }
  // factory Episode.fromJson(Map<String, dynamic> json) {
  //   return Episode(
  //       id: json['id'],
  //       name: json['name'],
  //       air_date: json['air_date'],
  //       characters: json['characters'].cast<String>(),
  //       url: json['url'],
  //       created: json['created']);
  // }

  Map<String, dynamic> toJson(episode) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['air_date'] = air_date;
    data['episode'] = episode;
    data['characters'] = characters;
    data['url'] = url;
    data['created'] = created;
    return data;
  }
}
