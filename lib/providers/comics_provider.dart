import 'package:flutter/material.dart';
import 'package:marvel_comics_app/models/comic.dart';
import 'package:marvel_comics_app/models/character.dart';
import 'package:marvel_comics_app/models/comic_page.dart';
import 'package:marvel_comics_app/services/api_service.dart';

class ComicsProvider with ChangeNotifier {
  final ApiService _apiService;
  
  List<Comic> _comics = [];
  List<Character> _characters = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  int _comicsOffset = 0;
  int _charactersOffset = 0;
  bool _hasMoreComics = true;
  bool _hasMoreCharacters = true;

  List<Comic> get comics => _comics;
  List<Character> get characters => _characters;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get searchQuery => _searchQuery;
  bool get hasMoreComics => _hasMoreComics;
  bool get hasMoreCharacters => _hasMoreCharacters;

  ComicsProvider({required ApiService apiService}) : _apiService = apiService {
    fetchComics();
    fetchCharacters();
  }

  Future<void> fetchComics({bool refresh = false}) async {
    if (refresh) {
      _comicsOffset = 0;
      _hasMoreComics = true;
    }

    if (!_hasMoreComics) return;

    if (_comicsOffset == 0) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    notifyListeners();

    try {
      final newComics = await _apiService.getComics(
        offset: _comicsOffset,
        titleStartsWith: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      
      if (refresh) {
        _comics = newComics;
      } else {
        _comics.addAll(newComics);
      }
      
      _comicsOffset += newComics.length;
      _hasMoreComics = newComics.length == 20; // Assuming page size is 20
    } catch (error) {
      debugPrint('Error fetching comics: $error');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchCharacters({bool refresh = false}) async {
    if (refresh) {
      _charactersOffset = 0;
      _hasMoreCharacters = true;
    }

    if (!_hasMoreCharacters) return;

    if (_charactersOffset == 0) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    notifyListeners();

    try {
      final newCharacters = await _apiService.getCharacters(
        offset: _charactersOffset,
        nameStartsWith: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      
      if (refresh) {
        _characters = newCharacters;
      } else {
        _characters.addAll(newCharacters);
      }
      
      _charactersOffset += newCharacters.length;
      _hasMoreCharacters = newCharacters.length == 20; // Assuming page size is 20
    } catch (error) {
      debugPrint('Error fetching characters: $error');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchComics(refresh: true);
    fetchCharacters(refresh: true);
  }

  Future<Comic> getComicById(int id) async {
    // First check if we already have this comic in our list
    final existingComic = _comics.firstWhere(
      (comic) => comic.id == id,
      orElse: () => Comic.mockComic(id), // Temporary placeholder
    );

    // If it's a mock, fetch the real data
    if (existingComic.thumbnailUrl.contains('placeholder')) {
      try {
        return await _apiService.getComicById(id);
      } catch (e) {
        debugPrint('Error fetching comic by ID: $e');
        return existingComic;
      }
    }

    return existingComic;
  }

  Future<Character> getCharacterById(int id) async {
    // First check if we already have this character in our list
    final existingCharacter = _characters.firstWhere(
      (character) => character.id == id,
      orElse: () => Character.mockCharacter(id), // Temporary placeholder
    );

    // If it's a mock, fetch the real data
    if (existingCharacter.thumbnailUrl.contains('placeholder')) {
      try {
        return await _apiService.getCharacterById(id);
      } catch (e) {
        debugPrint('Error fetching character by ID: $e');
        return existingCharacter;
      }
    }

    return existingCharacter;
  }

  Future<List<ComicPage>> getComicPages(int comicId) async {
    try {
      return await _apiService.getComicPages(comicId);
    } catch (e) {
      debugPrint('Error fetching comic pages: $e');
      return [];
    }
  }
}

