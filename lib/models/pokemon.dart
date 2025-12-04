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
  List<Types>? types; // <--- ADDED THIS
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
        this.types, // <--- ADDED THIS
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
    species = json['species'] != null ? Ability.fromJson(json['species']) : null;
    sprites = json['sprites'] != null ? Sprites.fromJson(json['sprites']) : null;
    if (json['stats'] != null) {
      stats = <Stats>[];
      json['stats'].forEach((v) {
        stats!.add(Stats.fromJson(v));
      });
    }
    // <--- ADDED THIS LOGIC
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types!.add(Types.fromJson(v));
      });
    }
    weight = json['weight'];
  }

}

class Types {
  int? slot;
  Ability? type;

  Types({this.slot, this.type});

  Types.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
    type = json['type'] != null ? Ability.fromJson(json['type']) : null;
  }
}