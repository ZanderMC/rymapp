import 'package:aymapp/models/character_model.dart';
import 'package:aymapp/models/episode_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  List<Character> characters = [];
  List<Episode> episodes = [];

  Future<void> getCharacters(int page) async {
    final result =
        await http.get(Uri.http("rickandmortyapi.com", "/api/character", {
      "page": page.toString(),
    }));

    final response = characterResponseFromJson(result.body);
    characters.addAll(response.results!);
    notifyListeners();
  }

  Future<List<Character>> getCharacter(String name) async {
    final result = await http.get(
        Uri.https("rickandmortyapi.com", '/api/character/', {'name': name}));
    final response = characterResponseFromJson(result.body);
    return response.results!;
  }

  Future<List<Episode>> getEpisodes(Character character) async {
    episodes = [];
    for (var i = 0; i < character.episode!.length; i++) {
      final result = await http.get(Uri.parse(character.episode![i]));
      final response = episodeFromJson(result.body);
      episodes.add(response);
      notifyListeners();
    }
    return episodes;
  }
}
