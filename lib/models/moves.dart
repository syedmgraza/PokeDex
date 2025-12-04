import 'ability.dart';

class Moves {
  Ability? move;

  Moves({this.move});

  Moves.fromJson(Map<String, dynamic> json) {
    move = json['move'] != null ? Ability.fromJson(json['move']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (move != null) {
      data['move'] = move!.toJson();
    }
    return data;
  }
}