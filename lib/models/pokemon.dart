import 'package:your_fav_pokemon/models/sprites.dart';
import 'package:your_fav_pokemon/models/stats.dart';

import 'abilities.dart';
import 'ability.dart';
import 'moves.dart';

class Pokemon {
  List<Abilities>? abilities;
  int? height;
  int? id;
  List<Moves>? moves;
  String? name;
  Ability? species;
  Sprites? sprites;
  List<Stats>? stats;
  int? weight;

  Pokemon(
      {this.abilities,
        this.height,
        this.id,
        this.moves,
        this.name,
        this.species,
        this.sprites,
        this.stats,
        this.weight});

  Pokemon.fromJson(Map<String, dynamic> json) {
    if (json['abilities'] != null) {
      abilities = <Abilities>[];
      json['abilities'].forEach((v) {
        abilities!.add(Abilities.fromJson(v));
      });
    }
    height = json['height'];
    id = json['id'];
    if (json['moves'] != null) {
      moves = <Moves>[];
      json['moves'].forEach((v) {
        moves!.add(Moves.fromJson(v));
      });
    }
    name = json['name'];
    species =
    json['species'] != null ? Ability.fromJson(json['species']) : null;
    sprites =
    json['sprites'] != null ? Sprites.fromJson(json['sprites']) : null;
    if (json['stats'] != null) {
      stats = <Stats>[];
      json['stats'].forEach((v) {
        stats!.add(Stats.fromJson(v));
      });
    }
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (abilities != null) {
      data['abilities'] = abilities!.map((v) => v.toJson()).toList();
    }

    data['height'] = height;

    data['id'] = id;

    if (moves != null) {
      data['moves'] = moves!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;

    if (species != null) {
      data['species'] = species!.toJson();
    }
    if (sprites != null) {
      data['sprites'] = sprites!.toJson();
    }
    if (stats != null) {
      data['stats'] = stats!.map((v) => v.toJson()).toList();
    }
    data['weight'] = weight;
    return data;
  }
}
