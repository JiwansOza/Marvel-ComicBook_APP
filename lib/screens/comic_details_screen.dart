import 'package:flutter/material.dart';
import 'package:marvel_comics_app/models/comic.dart';
import 'package:marvel_comics_app/screens/comic_reader_screen.dart';
import 'package:provider/provider.dart';
import 'package:marvel_comics_app/providers/favorites_provider.dart';
import 'package:intl/intl.dart';

class ComicDetailsScreen extends StatelessWidget {
  final Comic comic;

  const ComicDetailsScreen({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(comic.title),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final isFavorite = favoritesProvider.isComicFavorite(comic.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavoriteComic(comic.id);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'comic-${comic.id}',
              child: Image.network(
                comic.thumbnailUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comic.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context, 
                    'Published', 
                    _formatDate(comic.publishDate),
                  ),
                  _buildInfoRow(
                    context, 
                    'Price', 
                    '\$${comic.price.toStringAsFixed(2)}',
                  ),
                  _buildInfoRow(
                    context, 
                    'Pages', 
                    comic.pageCount.toString(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    comic.description.isEmpty 
                        ? 'No description available' 
                        : comic.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Creators',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...comic.creators.map((creator) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $creator',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )).toList(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComicReaderScreen(comic: comic),
                          ),
                        );
                      },
                      icon: const Icon(Icons.book),
                      label: const Text('Read Comic'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

