import 'package:flutter/material.dart';
import 'package:marvel_comics_app/widgets/comic_grid_item.dart';
import 'package:provider/provider.dart';
import 'package:marvel_comics_app/providers/comics_provider.dart';

class ComicsScreen extends StatelessWidget {
  final bool isSearchResult;
  
  const ComicsScreen({super.key, this.isSearchResult = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<ComicsProvider>(
      builder: (context, comicsProvider, child) {
        if (comicsProvider.isLoading && comicsProvider.comics.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final comics = comicsProvider.comics;
        
        if (comics.isEmpty) {
          return Center(
            child: Text(
              isSearchResult 
                ? 'No comics found matching your search'
                : 'No comics available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                !comicsProvider.isLoadingMore &&
                comicsProvider.hasMoreComics) {
              comicsProvider.fetchComics();
            }
            return false;
          },
          child: Stack(
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: comics.length,
                itemBuilder: (context, index) {
                  return ComicGridItem(comic: comics[index]);
                },
              ),
              if (comicsProvider.isLoadingMore)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                    padding: const EdgeInsets.all(8),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

