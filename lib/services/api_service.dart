import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marvel_comics_app/models/comic.dart';
import 'package:marvel_comics_app/models/character.dart';
import 'package:marvel_comics_app/models/comic_page.dart';

class ApiService {
  // Marvel API credentials
  final String _baseUrl = 'https://gateway.marvel.com/v1/public';
  final String _publicKey;
  final String _privateKey;

  ApiService({
    required String publicKey,
    required String privateKey,
  })  : _publicKey = publicKey,
        _privateKey = privateKey;

  // Generate authentication parameters required by Marvel API
  Map<String, String> _getAuthParams() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = _generateMd5(timestamp + _privateKey + _publicKey);
    
    return {
      'ts': timestamp,
      'apikey': _publicKey,
      'hash': hash,
    };
  }

  // Generate MD5 hash required for Marvel API authentication
  String _generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // Fetch comics from Marvel API
  Future<List<Comic>> getComics({int limit = 20, int offset = 0, String? titleStartsWith}) async {
    try {
      final params = _getAuthParams();
      params['limit'] = limit.toString();
      params['offset'] = offset.toString();
      params['orderBy'] = '-focDate'; // Sort by most recent first
      
      if (titleStartsWith != null && titleStartsWith.isNotEmpty) {
        params['titleStartsWith'] = titleStartsWith;
      }

      final uri = Uri.parse('$_baseUrl/comics').replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List;
        return results.map((comic) => Comic.fromJson(comic)).toList();
      } else {
        debugPrint('Error fetching comics: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        throw Exception('Failed to load comics');
      }
    } catch (e) {
      debugPrint('Exception fetching comics: $e');
      throw Exception('Failed to load comics: $e');
    }
  }

  // Fetch characters from Marvel API
  Future<List<Character>> getCharacters({int limit = 20, int offset = 0, String? nameStartsWith}) async {
    try {
      final params = _getAuthParams();
      params['limit'] = limit.toString();
      params['offset'] = offset.toString();
      params['orderBy'] = 'name'; // Sort alphabetically
      
      if (nameStartsWith != null && nameStartsWith.isNotEmpty) {
        params['nameStartsWith'] = nameStartsWith;
      }

      final uri = Uri.parse('$_baseUrl/characters').replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List;
        return results.map((character) => Character.fromJson(character)).toList();
      } else {
        debugPrint('Error fetching characters: ${response.statusCode}');
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      debugPrint('Exception fetching characters: $e');
      throw Exception('Failed to load characters: $e');
    }
  }

  // Fetch a specific comic by ID
  Future<Comic> getComicById(int id) async {
    try {
      final params = _getAuthParams();
      final uri = Uri.parse('$_baseUrl/comics/$id').replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List;
        if (results.isNotEmpty) {
          return Comic.fromJson(results.first);
        } else {
          throw Exception('Comic not found');
        }
      } else {
        debugPrint('Error fetching comic: ${response.statusCode}');
        throw Exception('Failed to load comic');
      }
    } catch (e) {
      debugPrint('Exception fetching comic: $e');
      throw Exception('Failed to load comic: $e');
    }
  }

  // Fetch a specific character by ID
  Future<Character> getCharacterById(int id) async {
    try {
      final params = _getAuthParams();
      final uri = Uri.parse('$_baseUrl/characters/$id').replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List;
        if (results.isNotEmpty) {
          return Character.fromJson(results.first);
        } else {
          throw Exception('Character not found');
        }
      } else {
        debugPrint('Error fetching character: ${response.statusCode}');
        throw Exception('Failed to load character');
      }
    } catch (e) {
      debugPrint('Exception fetching character: $e');
      throw Exception('Failed to load character: $e');
    }
  }

  // Fetch comic pages for reading
  // Note: Marvel API doesn't directly provide comic pages for reading
  // This is a simulated function that would need to be replaced with actual data source
  Future<List<ComicPage>> getComicPages(int comicId) async {
    try {
      // In a real app, you would fetch the actual comic pages from a source
      // For demo purposes, we'll return sample pages
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      // Create sample pages (in a real app, these would come from an API or asset)
      return List.generate(
        10,
        (index) => ComicPage(
          id: index + 1,
          pageNumber: index + 1,
          imageUrl: '/placeholder.svg?height=1200&width=800',
          comicId: comicId,
        ),
      );
    } catch (e) {
      debugPrint('Exception fetching comic pages: $e');
      throw Exception('Failed to load comic pages: $e');
    }
  }
}

