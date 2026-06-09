import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/mediacard.dart';
import '../bottom_nav/forum_screen.dart';


class TmdbService {
  static const String _apiKey = '69c1a1a1441bdb5f8aa143d1019f1103'; 
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _movieType = '/movie';

  Future<List<Media>> getTrending(String type) async {
    final url = Uri.parse('$_baseUrl/trending$type/day?api_key=$_apiKey&language=pt-PT');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        return results.map((json) {
          return Media(
            id: json['id'],
            title: json['title'] ?? json['name'] ?? '',
            type: type == _movieType ? 'Movie' : 'TV Show',
            rating: (json['vote_average'] as num).toDouble(),
            imageUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
            overview: json['overview'] ?? '',
            posterPath: json['poster_path'] ?? '',
            releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
          );
        }).toList();
      } else {
        throw Exception('Erro a comunicar com a TMDB');
      }
    } catch (e) {
      throw Exception('Erro de ligação: $e');
    }
  }

  Future<List<Media>> search(String query) async {
    final url = Uri.parse('$_baseUrl/search/multi?api_key=$_apiKey&language=pt-PT&query=$query');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        return results
          .where((json) => json['media_type'] == 'movie' || json['media_type'] == 'tv')
          .map((json) {
          final mediaType = json['media_type'];
          return Media(
            id: json['id'],
            title: json['title'] ?? json['name'] ?? '',
            type: mediaType == 'movie' ? 'Movie' : 'TV Show',
            rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
            imageUrl: json['poster_path'] != null 
              ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}' : '',
            overview: json['overview'] ?? '',
            posterPath: json['poster_path'] ?? '',
            releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
          );
        }).toList();
      } else {
        throw Exception('Erro a comunicar com a TMDB');
      }
    } catch (e) {
      throw Exception('Erro de ligação: $e');
    }
  }

  Future<List<DiscussedItem>> getMostDiscussed() async {
    // Oredered by 'vote_count.desc'
    final url = Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&sort_by=vote_count.desc&language=pt-PT');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        // First 4 most discussed items
        return results.take(4).map((json) {
          return DiscussedItem(
            title: json['title'] ?? json['original_title'] ?? 'Sem Título',
            comments: json['vote_count'] ?? 0, // Votes used as comments
            rating: (json['vote_average'] as num).toDouble(),
            icon: Icons.movie, 
            imageUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
          );
        }).toList();
      } else {
        throw Exception('Erro a comunicar com a TMDB');
      }
    } catch (e) {
      throw Exception('Erro de ligação: $e');
    }
  }
}