import 'package:flutter/material.dart';
import 'package:marvel_comics_app/models/character.dart';
import 'package:marvel_comics_app/models/comic.dart';
import 'package:marvel_comics_app/widgets/comic_grid_item.dart';
import 'package:marvel_comics_app/widgets/character_grid_item.dart';
import 'package:provider/provider.dart';
import 'package:marvel_comics_app/providers/comics_provider.dart';
import 'package:marvel_comics_app/providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Comics'),
              Tab(text: 'Characters'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _FavoriteComicsTab(),
                _FavoriteCharactersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteComicsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoritesProvider, ComicsProvider>(
      builder: (context, favoritesProvider, comicsProvider, child) {
        final favoriteIds = favoritesProvider.favoriteComics;

        if (favoriteIds.isEmpty) {
          return const Center(
            child: Text('No favorite comics yet'),
          );
        }

        return FutureBuilder<List<Comic>>(
          future: Future.wait(favoriteIds.map((id) => comicsProvider.getComicById(id))),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading favorite comics'));
            }
            final favoriteComics = snapshot.data ?? [];

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favoriteComics.length,
              itemBuilder: (context, index) {
                return ComicGridItem(comic: favoriteComics[index]);
              },
            );
          },
        );
      },
    );
  }
}

class _FavoriteCharactersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoritesProvider, ComicsProvider>(
      builder: (context, favoritesProvider, comicsProvider, child) {
        final favoriteIds = favoritesProvider.favoriteCharacters;

        if (favoriteIds.isEmpty) {
          return const Center(
            child: Text('No favorite characters yet'),
          );
        }

        return FutureBuilder<List<Character>>(
          future: Future.wait(favoriteIds.map((id) => comicsProvider.getCharacterById(id))),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading favorite characters'));
            }
            final favoriteCharacters = snapshot.data ?? [];

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favoriteCharacters.length,
              itemBuilder: (context, index) {
                return CharacterGridItem(character: favoriteCharacters[index]);
              },
            );
          },
        );
      },
    );
  }
}