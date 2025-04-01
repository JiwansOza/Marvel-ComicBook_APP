import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marvel_comics_app/providers/comics_provider.dart';

class MarvelSearchBar extends StatefulWidget {
  const MarvelSearchBar({super.key});

  @override
  State<MarvelSearchBar> createState() => _MarvelSearchBarState();
}

class _MarvelSearchBarState extends State<MarvelSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search comics and characters',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              Provider.of<ComicsProvider>(context, listen: false).setSearchQuery('');
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        onChanged: (value) {
          Provider.of<ComicsProvider>(context, listen: false).setSearchQuery(value);
        },
      ),
    );
  }
}

