import 'package:flutter/material.dart';
import 'package:marvel_comics_app/models/comic.dart';
import 'package:marvel_comics_app/models/comic_page.dart';
import 'package:marvel_comics_app/providers/comics_provider.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ComicReaderScreen extends StatefulWidget {
  final Comic comic;

  const ComicReaderScreen({super.key, required this.comic});

  @override
  State<ComicReaderScreen> createState() => _ComicReaderScreenState();
}

class _ComicReaderScreenState extends State<ComicReaderScreen> {
  late PageController _pageController;
  late Future<List<ComicPage>> _pagesFuture;
  int _currentPage = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadPages();
  }

  void _loadPages() {
    final comicsProvider = Provider.of<ComicsProvider>(context, listen: false);
    _pagesFuture = comicsProvider.getComicPages(widget.comic.id);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _showControls
          ? AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              title: Text(widget.comic.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    _showComicInfo(context);
                  },
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: _toggleControls,
        child: FutureBuilder<List<ComicPage>>(
          future: _pagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading comic: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final pages = snapshot.data ?? [];
            if (pages.isEmpty) {
              return const Center(
                child: Text(
                  'No pages available for this comic',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Stack(
              children: [
                // Comic pages with zoom capability
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(pages[index].imageUrl),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  itemCount: pages.length,
                  loadingBuilder: (context, event) => Center(
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                    ),
                  ),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  pageController: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),

                // Page indicator
                if (_showControls)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Page ${_currentPage + 1} of ${pages.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Navigation buttons
                if (_showControls)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous page button
                        GestureDetector(
                          onTap: _currentPage > 0
                              ? () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          child: Container(
                            width: 60,
                            color: Colors.transparent,
                            child: _currentPage > 0
                                ? Icon(
                                    Icons.chevron_left,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                        // Next page button
                        GestureDetector(
                          onTap: _currentPage < pages.length - 1
                              ? () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          child: Container(
                            width: 60,
                            color: Colors.transparent,
                            child: _currentPage < pages.length - 1
                                ? Icon(
                                    Icons.chevron_right,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showComicInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.comic.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Published: ${_formatDate(widget.comic.publishDate)}'),
            const SizedBox(height: 8),
            Text('Pages: ${widget.comic.pageCount}'),
            const SizedBox(height: 8),
            Text('Price: \$${widget.comic.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Creators:'),
            ...widget.comic.creators.map((creator) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text('• $creator'),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

