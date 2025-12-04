import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:your_fav_pokemon/models/pokemon.dart'; // Ensure this import works
import 'package:your_fav_pokemon/providers/pokemon_data_providers.dart';

import 'package:your_fav_pokemon/utils/pokemon_type_colors.dart';

import '../pages/pokemon_detail_screen.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonURL;
  const PokemonCard({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonAsync = ref.watch(pokemonDataProvider(pokemonURL));

    return pokemonAsync.when(
      data: (data) => _buildCard(context, false, data),
      error: (error, stackTrace) => _buildErrorCard(),
      loading: () => _buildCard(context, true, null),
    );
  }

  Widget _buildCard(BuildContext context, bool isLoading, Pokemon? pokemon) {
    // 1. Get the primary type (e.g., "grass")
    final type = pokemon?.types?.isNotEmpty == true
        ? pokemon!.types!.first.type?.name
        : "normal";

    // 2. Get the corresponding color
    final cardColor = isLoading ? Colors.white : PokemonTypeColors.getColor(type);

    return GestureDetector(
      onTap: () {
        if (pokemon != null) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return PokemonDetailScreen(
                pokemon: pokemon,
                pokemonURL: pokemonURL,
              );
            },
          );
        }
      },
      child: Skeletonizer(
        enabled: isLoading,
        ignoreContainers: false,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // 3. Apply the dynamic color with a subtle gradient for a "Pro" look
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor.withOpacity(0.8), // Slightly lighter
                cardColor,                  // Actual color
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.4), // Colored shadow!
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pokemon?.name != null
                          ? pokemon!.name![0].toUpperCase() + pokemon.name!.substring(1)
                          : "Pokemon Name",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text for contrast
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    pokemon?.id != null ? '#${pokemon?.id.toString().padLeft(3, '0')}' : '#001',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8), // Semi-transparent white
                    ),
                  ),
                ],
              ),

              // IMAGE AREA
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Circle (White semi-transparent)
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (pokemon?.sprites?.frontDefault != null)
                      Hero(
                        tag: pokemon!.id.toString(),
                        child: Image.network(
                          pokemon.sprites!.frontDefault!,
                          fit: BoxFit.contain,
                          height: 120,
                        ),
                      )
                    else
                      const Icon(Icons.image_not_supported, color: Colors.white54),
                  ],
                ),
              ),

              // FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1), // Darkened pill
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      type?.toUpperCase() ?? "TYPE",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(Icons.favorite_border, color: Colors.white, size: 24)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.red),
      ),
    );
  }
}