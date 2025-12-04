class PokemonListResult {
  String? name;
  String? url;

  PokemonListResult({this.name, this.url});

  PokemonListResult.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}