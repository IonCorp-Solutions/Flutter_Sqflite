import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class Service{
  String baseUrl = 'https://api.jikan.moe/v4/top/anime';

  Future<List<Anime>?>? getAnimeList (int limit, int offset) async {
    var response = await http.get(Uri.parse('$baseUrl?limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Anime> animeList = [];
      for (var item in data['data']) {
        animeList.add(Anime.fromJson(item));
      }
      return animeList;
    }
    return null;
  }

}