import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_fav_pokemon/models/pokemon.dart';
import 'package:your_fav_pokemon/providers/favourite_pokemon_provider.dart';

class PokemonDetailScreen extends ConsumerWidget {
  final Pokemon pokemon;
  final String pokemonURL;

  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
    required this.pokemonURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch favorites to toggle the heart icon
    final favouritePokemons = ref.watch(favouritePokemonProvider);
    final isFavourite = favouritePokemons.contains(pokemonURL);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9, // Takes 90% of screen
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // 1. The Drag Handle (Visual cue that this is a sheet)
          const SizedBox(height: 10),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 2. The Content
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Header with Image and Name
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pokemon.name?.toUpperCase() ?? "UNKNOWN",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                // FIXED: Removed baseExperience, showing only ID
                                Text(
                                  "ID: #${pokemon.id}",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                final notifier = ref.read(favouritePokemonProvider.notifier);
                                if (isFavourite) {
                                  notifier.removeFavouritePokemon(pokemonURL);
                                } else {
                                  notifier.addFavouritePokemon(pokemonURL);
                                }
                              },
                              icon: Icon(
                                isFavourite ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                                size: 35,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        // HERO IMAGE: This makes the image "fly" from the previous screen
                        Hero(
                          tag: pokemon.id.toString(),
                          child: Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            child: pokemon.sprites?.frontDefault != null
                                ? Image.network(
                              pokemon.sprites!.frontDefault!,
                              fit: BoxFit.contain,
                            )
                                : const Icon(Icons.image, size: 100),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Physical Stats (Height / Weight)
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAttributeBadge("Height", "${pokemon.height} dm"),
                      _buildAttributeBadge("Weight", "${pokemon.weight} hg"),
                    ],
                  ),
                ),

                // Base Stats Section
                _buildSectionTitle("Base Stats"),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final stat = pokemon.stats![index];
                      return _buildStatRow(
                          stat.stat?.name ?? "Stat", stat.baseStat ?? 0);
                    },
                    childCount: pokemon.stats?.length ?? 0,
                  ),
                ),

                // Abilities Section
                _buildSectionTitle("Abilities"),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10,
                      children: pokemon.abilities?.map((e) {
                        return Chip(
                          backgroundColor: Colors.blue.shade50,
                          label: Text(
                            e.ability?.name?.toUpperCase() ?? "",
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        );
                      }).toList() ?? [],
                    ),
                  ),
                ),

                // Moves Section
                _buildSectionTitle("Moves"),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: pokemon.moves?.take(15).map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            e.move?.name ?? "",
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        );
                      }).toList() ?? [],
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Section Titles
  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Helper: Stat Row (Progress Bar)
  Widget _buildStatRow(String name, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              name.toUpperCase(),
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (value / 200).clamp(0.0, 1.0), // Assuming max stat ~200
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: value > 100 ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Helper: Physical Attributes
  Widget _buildAttributeBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ],
      ),
    );
  }
}