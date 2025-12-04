import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:your_fav_pokemon/providers/pokemon_data_providers.dart';
import '../models/pokemon.dart';

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
    return Skeletonizer(
      enabled: isLoading,
      // We want the container shape to be part of the skeleton effect
      ignoreContainers: false,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Softer, modern corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Professional subtle shadow
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: Name and ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pokemon?.name != null
                        ? pokemon!.name![0].toUpperCase() + pokemon.name!.substring(1)
                        : "Pokemon Name",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  pokemon?.id != null ? '#${pokemon?.id.toString().padLeft(3, '0')}' : '#001',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),

            // 2. The Image (With a subtle background blob)
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative background circle
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // The actual image
                  pokemon?.sprites?.frontDefault != null
                      ? Image.network(
                    pokemon!.sprites!.frontDefault!,
                    fit: BoxFit.contain,
                    height: 100,
                  )
                      : const Icon(Icons.image_not_supported, color: Colors.grey),
                ],
              ),
            ),

            // 3. Footer: Moves Chip & Heart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "Moves" Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${pokemon?.moves?.length ?? 0} Moves",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                // Heart Icon
                Icon(
                  Icons.favorite,
                  color: Colors.red.shade400,
                  size: 20,
                )
              ],
            )
          ],
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