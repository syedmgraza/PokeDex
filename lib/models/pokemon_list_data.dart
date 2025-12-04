import 'package:your_fav_pokemon/models/pokemon_list_result.dart';

class PokemonListData {
  int? count;
  String? next;
  String? previous;
  List<PokemonListResult>? results;

  PokemonListData({this.count, this.next, this.previous, this.results});

  PokemonListData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <PokemonListResult>[];
      json['results'].forEach((v) {
        results!.add(PokemonListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  PokemonListData copyWith({
    int? count,
    String? next,
    String? previous,
    List<PokemonListResult>? results,
  }) {
    return PokemonListData(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }
}
