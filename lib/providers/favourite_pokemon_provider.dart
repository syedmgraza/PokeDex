
import 'package:flutter_riverpod/legacy.dart';
import 'package:get_it/get_it.dart';
import 'package:your_fav_pokemon/services/database_service.dart';


final favouritePokemonProvider =StateNotifierProvider<FavouritePokemonProvider,List<String>>((ref){
  return FavouritePokemonProvider([]);
});


class FavouritePokemonProvider extends StateNotifier<List<String>>{

  final DatabaseService _databaseService=GetIt.instance.get<DatabaseService>();
  FavouritePokemonProvider(super._state){
    _setup();
  }

  final FAVOURITE_POKEMON_lIST_KEY="FAVOURITE_POKEMON_lIST_KEY";

  Future<void> _setup() async {
    List<String>? result= await _databaseService.getList(FAVOURITE_POKEMON_lIST_KEY);
    state=result ?? [];
  }

  void addFavouritePokemon(String url){
    state=[...state,url];
    _databaseService.savaList(FAVOURITE_POKEMON_lIST_KEY, state);
  }

  void removeFavouritePokemon(String url){
    state=state.where((e)=> e !=url).toList();
    _databaseService.savaList(FAVOURITE_POKEMON_lIST_KEY, state);
  }
}