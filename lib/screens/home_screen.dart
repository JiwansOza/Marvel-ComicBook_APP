import 'package:flutter/material.dart';
import 'package:marvel_comics_app/widgets/app_drawer.dart';
import 'package:marvel_comics_app/screens/comics_screen.dart';
import 'package:marvel_comics_app/screens/characters_screen.dart';
import 'package:marvel_comics_app/screens/favorites_screen.dart';
import 'package:marvel_comics_app/widgets/search_bar.dart';
import 'package:provider/provider.dart';
import 'package:marvel_comics_app/providers/comics_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const ComicsScreen(),
    const CharactersScreen(),
    const FavoritesScreen(),
  ];

  final List<String> _titles = [
    'Marvel Comics',
    'Marvel Characters',
    'My Favorites',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MarvelSearchDelegate(),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        currentIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
        },
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Comics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class MarvelSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final comicsProvider = Provider.of<ComicsProvider>(context, listen: false);
    comicsProvider.setSearchQuery(query);
    
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
                ComicsScreen(isSearchResult: true),
                CharactersScreen(isSearchResult: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Search for Marvel comics or characters'),
      );
    }
    
    return buildResults(context);
  }
}