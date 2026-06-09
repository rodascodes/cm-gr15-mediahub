import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/mediacard.dart';


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

  Future<List<Media>> getMostDiscussed() async {
  final movieUrl = Uri.parse('$_baseUrl/discover/movie?api_key=$_apiKey&language=pt-PT&sort_by=vote_count.desc');
  final tvUrl = Uri.parse('$_baseUrl/discover/tv?api_key=$_apiKey&language=pt-PT&sort_by=vote_count.desc');

  try {
      final responses = await Future.wait([
        http.get(movieUrl),
        http.get(tvUrl)
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final movieData = json.decode(responses[0].body)['results'] as List;
        final tvData = json.decode(responses[1].body)['results'] as List;

        final movies = movieData.map((json) {
        final int voteCount = json['vote_count'] ?? 0;
        return Media(
          id: json['id'],
          title: json['title'] ?? '',
          type: 'Movie • $voteCount comments', 
          rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
          imageUrl: json['poster_path'] != null ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}' : '',
          overview: json['overview'] ?? '',
          posterPath: json['poster_path'] ?? '',
          releaseDate: json['release_date'] ?? '',
        );
      }).toList();

      final tvShows = tvData.map((json) {
        final int voteCount = json['vote_count'] ?? 0;
        return Media(
          id: json['id'],
          title: json['name'] ?? '', 
          type: 'TV Show • $voteCount comments', 
          rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
          imageUrl: json['poster_path'] != null ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}' : '',
          overview: json['overview'] ?? '',
          posterPath: json['poster_path'] ?? '',
          releaseDate: json['first_air_date'] ?? '',
        );
      }).toList();

      final combined = [...movies, ...tvShows];

      return combined;

      } else {
        throw Exception('Erro a comunicar com a TMDB');
      }
    } catch (e) {
      throw Exception('Erro de ligação: $e');
    }
  }

  Future<Map<String, String>> getTitleAndPoster(int id, String mediaType) async {
    //Movies => movie
    if(mediaType.toLowerCase().startsWith('m'))
    {
      mediaType = mediaType.toLowerCase().substring(0, mediaType.length - 1);
    }
    //TV => tv
    else if (mediaType.toLowerCase().startsWith('t'))
    {
      mediaType = mediaType.toLowerCase();
    }

    final url = Uri.parse(
      '$_baseUrl/$mediaType/$id?api_key=$_apiKey&language=pt-PT',
    );

    final response = await http.get(url);

    if (response.statusCode == 200)
    {
      final data = jsonDecode(response.body);
      return {
        'title': data['title'] ?? data['name'] ?? '',
        'posterUrl': data['poster_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${data['poster_path']}'
            : '',
      };
    }

    throw Exception('Title not found');
  }

  Future<Media> getMediaFromId(int id, String mediaType) async
  {
    //Movies => movie
    if(mediaType.toLowerCase().startsWith('m'))
    {
      mediaType = mediaType.toLowerCase().substring(0, mediaType.length - 1);
    }
    //TV => tv
    else if (mediaType.toLowerCase().startsWith('t'))
    {
      mediaType = mediaType.toLowerCase();
    }

    final url = Uri.parse(
      '$_baseUrl/$mediaType/$id?api_key=$_apiKey&language=pt-PT',
    );

    final response = await http.get(url);

    if(response.statusCode == 200)
    {
      final data = jsonDecode(response.body);

      return Media(
        id: data['id'],
        title: data['title'] ?? data['name'] ?? '',
        type: mediaType,
        rating: (data['vote_average'] as num).toDouble(),
        imageUrl: 'https://image.tmdb.org/t/p/w500${data['poster_path']}',
        overview: data['overview'] ?? '',
        posterPath: data['poster_path'] ?? '',
        releaseDate: data['release_date'] ?? data['first_air_date'] ?? '',
      );
    }

    throw Exception("It's joever");
  }
}