import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/mediacard.dart';

class TmdbService {
  static const String _apiKey = '69c1a1a1441bdb5f8aa143d1019f1103'; 
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Media>> getTrendingMovies() async {
    final url = Uri.parse('$_baseUrl/trending/movie/day?api_key=$_apiKey&language=pt-PT');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        return results.map((json) {
          return Media(
            id: json['id'],
            title: json['title'] ?? '',
            type: 'Movie',
            rating: (json['vote_average'] as num).toDouble(),
            icon: Icons.movie,
            color: Colors.orange,

            overview: json['overview'] ?? '',
            posterPath: json['poster_path'] ?? '',
            releaseDate: json['release_date'] ?? '',
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