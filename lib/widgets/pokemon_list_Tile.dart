import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:your_fav_pokemon/providers/favourite_pokemon_provider.dart';
import 'package:your_fav_pokemon/providers/pokemon_data_providers.dart';
import '../models/pokemon.dart';

class PokemonListTile extends ConsumerWidget {
  final String polemonURL;

  const PokemonListTile({super.key, required this.polemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific pokemon data
    final pokemonAsync = ref.watch(pokemonDataProvider(polemonURL));

    // Watch favorites list to determine heart status
    final favouritePokemons = ref.watch(favouritePokemonProvider);
    final isFavourite = favouritePokemons.contains(polemonURL);

    return pokemonAsync.when(
      data: (pokemon) => _buildTile(context, ref, pokemon, isFavourite, false),
      error: (error, stackTrace) => _buildErrorTile(),
      // Pass 'null' for pokemon and true for isLoading to trigger Skeletonizer
      loading: () => _buildTile(context, ref, null, false, true),
    );
  }

  Widget _buildTile(BuildContext context, WidgetRef ref, Pokemon? pokemon,
      bool isFavourite, bool isLoading) {

    // Helper to capitalize first letter (e.g., "pikachu" -> "Pikachu")
    String formatName(String? name) {
      if (name == null || name.isEmpty) return "Loading...";
      return name[0].toUpperCase() + name.substring(1);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Skeletonizer(
        enabled: isLoading,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16), // Smooth corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), // Subtle shadow
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

            // 1. The Image (Leading)
            leading: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Light background for image
                borderRadius: BorderRadius.circular(12),
              ),
              child: pokemon?.sprites?.frontDefault != null
                  ? Image.network(
                pokemon!.sprites!.frontDefault!,
                fit: BoxFit.contain,
              )
                  : const Icon(Icons.image_not_supported, color: Colors.grey),
            ),

            // 2. The Name (Title)
            title: Text(
              formatName(pokemon?.name ?? "Pokemon Name"),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            // 3. The Details (Subtitle)
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                "Moves: ${pokemon?.moves?.length.toString() ?? "00"}",
                style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),

            // 4. The Favorite Button (Trailing)
            trailing: IconButton(
              onPressed: isLoading
                  ? null // Disable button while loading
                  : () {
                final notifier = ref.read(favouritePokemonProvider.notifier);
                if (isFavourite) {
                  notifier.removeFavouritePokemon(polemonURL);
                } else {
                  notifier.addFavouritePokemon(polemonURL);
                }
              },
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: isFavourite ? Colors.redAccent : Colors.grey.shade400,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // A simple fallback if data fails to load
  Widget _buildErrorTile() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 12),
          Text("Failed to load Pokemon"),
        ],
      ),
    );
  }
}