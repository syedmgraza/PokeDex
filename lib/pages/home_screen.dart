import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// Note: legacy.dart is rarely needed in modern Riverpod 2.0+,
// ensure your pubspec matches the import style.
// import 'package:flutter_riverpod/legacy.dart';

import 'package:your_fav_pokemon/controllers/home_page_controller.dart';
import 'package:your_fav_pokemon/models/page_data.dart';
import 'package:your_fav_pokemon/models/pokemon_list_result.dart';
import 'package:your_fav_pokemon/providers/favourite_pokemon_provider.dart';
import 'package:your_fav_pokemon/widgets/pokemon_card.dart';
import 'package:your_fav_pokemon/widgets/pokemon_list_Tile.dart';

final homePageControllerProvider = StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late HomePageController _homePageController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Accessing notifier via ref inside a method is safer via ref.read if stored instance is stale,
      // but strictly speaking, using the cached controller is fine here.
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watchers
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    final homePageData = ref.watch(homePageControllerProvider);
    final favouritePokemons = ref.watch(favouritePokemonProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Professional off-white background
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. Modern Floating App Bar
          SliverAppBar(
            title: const Text(
              'POKEPEDIA',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            centerTitle: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black54),
                onPressed: () {}, // Add search logic later
              )
            ],
          ),

          // 2. Favourites Section Header
          _buildSectionHeader("Favourites"),

          // 3. Favourites Grid (Horizontal)
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: favouritePokemons.isEmpty
                  ? _buildEmptyState()
                  : _buildFavouritesList(favouritePokemons),
            ),
          ),

          // 4. All Pokemon Section Header
          _buildSectionHeader("All Pokemon"),

          // 5. Infinite List of Pokemon
          homePageData.data == null
              ? const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()))
              : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  PokemonListResult pokemon = homePageData.data!.results![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: PokemonListTile(polemonURL: pokemon.url!),
                  );
                },
                childCount: homePageData.data?.results?.length ?? 0,
              ),
            ),
          ),

          // 6. Bottom Loading Indicator (Optional but professional)
          const SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Section Headers
  Widget _buildSectionHeader(String title) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // Helper Widget: The Horizontal Grid
  Widget _buildFavouritesList(List<String> favourites) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      itemCount: favourites.length,
      itemBuilder: (context, index) {
        String pokemon = favourites[index];
        // Wrapping in container to give the card some breathing room
        return Container(
          width: MediaQuery.of(context).size.width * 0.45, // Responsive width
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Expanded(
                child: PokemonCard(pokemonURL: pokemon),
              ),
              // If you had a 2-row grid logic before, you can use a GridView inside here,
              // but a simple horizontal list is often cleaner for "Featured/Favorites".
            ],
          ),
        );
      },
    );
  }

  // Helper Widget: Empty State
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            "No favourites yet",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}