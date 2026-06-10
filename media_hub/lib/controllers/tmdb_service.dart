import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:media_hub/utils/app_util_classes.dart';
import '../utils/mediacard.dart';


/**
 * Serviço que interage com a API do TMDB (The Movie Database).
 * Fornece métodos para obter filmes, séries, pesquisar e obter detalhes.
 */
class TmdbService {
  static const String _apiKey = '69c1a1a1441bdb5f8aa143d1019f1103'; 
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _movieType = '/movie';

  /**
   * Obtém média em tendência (trending).
   * 
   * @param type O tipo de média ('/movie' ou '/tv')
   * @return Lista de média em tendência
   * @throws Exception se houver erro na comunicação com a TMDB
   */
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

  /**
   * Pesquisa média por palavra-chave na TMDB.
   * 
   * @param query A palavra-chave a pesquisar
   * @return Lista de média encontrada
   * @throws Exception se houver erro na comunicação com a TMDB
   */
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

  /**
   * Obtém a média mais discutida (com mais votos).
   * Combina filmes e séries ordenados por número de comentários.
   * 
   * @return Lista de média mais discutida
   * @throws Exception se houver erro na comunicação com a TMDB
   */
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

  /**
   * Obtém o título e poster de um filme/série pelo ID.
   * Útil para a seção de favoritos no perfil.
   * 
   * @param id O ID da média no TMDB
   * @param mediaType O tipo de média ('movie', 'tv', etc)
   * @return Mapa com 'title' e 'posterUrl'
   * @throws Exception se a média não for encontrada
   */
  Future<Map<String, String>> getTitleAndPoster(int id, String mediaType) async {
    //have to do this because of the way things were coded, tv can be "TV"; "TV Shows"; or "TV Show 3465 comments"
    //since tmdb search requires the mediatype to either be "movie" or "tv" in the url's formation, I had to format whatever I was getting here so it doens't break
    if(mediaType.startsWith("t"))
    {
      mediaType = mediaType.substring(0, 2).trim();
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

  /**
   * Obtém os detalhes completos de uma média pelo ID.
   * 
   * @param id O ID da média no TMDB
   * @param mediaType O tipo de média ('movie', 'tv', etc)
   * @return Objeto [Media] com todos os detalhes
   * @throws Exception se a média não for encontrada
   */
  Future<Media> getMediaFromId(int id, String mediaType) async
  {
    //already explained this in the function before this one, it's so the url is valid for tmdb checkup
    if(mediaType.startsWith("t"))
    {
      mediaType = mediaType.substring(0, 2).trim();
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

  /**
   * Obtém uma lista de média a partir de uma lista de [MediaStats].
   * Usado para carregar detalhes completos das médias avaliadas.
   * 
   * @param mslist Lista de estatísticas de média
   * @return Lista de objetos [Media] com detalhes completos
   */
  Future<List<Media>> getMediaListFromMediaStatsList(List<MediaStats> mslist) async
  {
    List<Media> mediaList = [];
    for(MediaStats m in mslist)
    {
      mediaList.add(await getMediaFromId(m.id, m.mediaType));
    }
    return mediaList;
  }
}