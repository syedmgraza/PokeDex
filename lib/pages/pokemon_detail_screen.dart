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
    final favouritePokemons = ref.watch(favouritePokemonProvider);
    final isFavourite = favouritePokemons.contains(pokemonURL);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Expanded(
            child: CustomScrollView(
              slivers: [
                // Header: Name, ID, Heart, and ANIMATED IMAGE
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
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
                                  Text(
                                    "ID: #${pokemon.id}",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
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
                        const SizedBox(height: 30),

                        // --- ANIMATION SECTION START ---
                        Hero(
                          tag: pokemon.id.toString(),
                          child: Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            // Call the helper method to choose the best image
                            child: _buildPokemonImage(),
                          ),
                        ),
                        // --- ANIMATION SECTION END ---
                      ],
                    ),
                  ),
                ),

                // Physical Stats
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAttributeBadge("Height", "${pokemon.height} dm"),
                      _buildAttributeBadge("Weight", "${pokemon.weight} hg"),
                    ],
                  ),
                ),

                // Base Stats
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

                // Abilities
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

                // Moves
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

                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Logic to determine which image to show
  Widget _buildPokemonImage() {
    // 1. Try Showdown (Best Quality GIF)
    if (pokemon.sprites?.showdownFront != null) {
      return Image.network(
        pokemon.sprites!.showdownFront!,
        fit: BoxFit.contain,
        // Key helps Flutter differentiate between the static image on the previous screen
        // and this animated one, preventing hero glitches.
        key: ValueKey("showdown-${pokemon.id}"),
      );
    }

    // 2. Try Gen 5 (Pixel Art GIF)
    if (pokemon.sprites?.animatedFront != null) {
      return Image.network(
        pokemon.sprites!.animatedFront!,
        fit: BoxFit.contain,
        scale: 0.5, // Pixel art needs to be bigger
        key: ValueKey("animated-${pokemon.id}"),
      );
    }

    // 3. Fallback to Static Image
    if (pokemon.sprites?.frontDefault != null) {
      return Image.network(
        pokemon.sprites!.frontDefault!,
        fit: BoxFit.contain,
      );
    }

    return const Icon(Icons.image_not_supported, size: 80, color: Colors.black12);
  }

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
                  widthFactor: (value / 200).clamp(0.0, 1.0),
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