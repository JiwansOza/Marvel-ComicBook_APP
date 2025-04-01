import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<int> _favoriteComics = {};
  final Set<int> _favoriteCharacters = {};

  Set<int> get favoriteComics => _favoriteComics;
  Set<int> get favoriteCharacters => _favoriteCharacters;

  bool isComicFavorite(int id) {
    return _favoriteComics.contains(id);
  }

  bool isCharacterFavorite(int id) {
    return _favoriteCharacters.contains(id);
  }

  void toggleFavoriteComic(int id) {
    if (_favoriteComics.contains(id)) {
      _favoriteComics.remove(id);
    } else {
      _favoriteComics.add(id);
    }
    notifyListeners();
  }

  void toggleFavoriteCharacter(int id) {
    if (_favoriteCharacters.contains(id)) {
      _favoriteCharacters.remove(id);
    } else {
      _favoriteCharacters.add(id);
    }
    notifyListeners();
  }
}

