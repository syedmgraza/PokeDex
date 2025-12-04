class Sprites {
  // Static Images
  String? backDefault;
  String? backFemale;
  String? backShiny;
  String? backShinyFemale;
  String? frontDefault;
  String? frontFemale;
  String? frontShiny;
  String? frontShinyFemale;

  // Animations (New Fields)
  String? animatedFront;      // Classic Gen 5 Pixel Animation
  String? showdownFront;      // High Quality Modern Animation

  Sprites({
    this.backDefault,
    this.backFemale,
    this.backShiny,
    this.backShinyFemale,
    this.frontDefault,
    this.frontFemale,
    this.frontShiny,
    this.frontShinyFemale,
    this.animatedFront,
    this.showdownFront,
  });

  Sprites.fromJson(Map<String, dynamic> json) {
    // 1. Basic Static Images
    backDefault = json['back_default'];
    backFemale = json['back_female'];
    backShiny = json['back_shiny'];
    backShinyFemale = json['back_shiny_female'];
    frontDefault = json['front_default'];
    frontFemale = json['front_female'];
    frontShiny = json['front_shiny'];
    frontShinyFemale = json['front_shiny_female'];

    // 2. Extract Showdown Animation (High Quality) - "other" -> "showdown"
    if (json['other'] != null && json['other']['showdown'] != null) {
      showdownFront = json['other']['showdown']['front_default'];
    }

    // 3. Extract Gen 5 Animation (Pixel Art) - "versions" -> "generation-v" -> "black-white" -> "animated"
    if (json['versions'] != null &&
        json['versions']['generation-v'] != null &&
        json['versions']['generation-v']['black-white'] != null &&
        json['versions']['generation-v']['black-white']['animated'] != null) {
      animatedFront = json['versions']['generation-v']['black-white']['animated']['front_default'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['front_default'] = frontDefault;
    data['front_shiny'] = frontShiny;
    data['back_default'] = backDefault;
    // We usually don't need to write the deep nested animations back to JSON
    return data;
  }
}