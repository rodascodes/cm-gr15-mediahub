import 'package:cloud_firestore/cloud_firestore.dart';

//all the media types the app may have
enum MediaType {
  movies,
  books,
  music,
  videogames,
}

class Media {
  final String id;
  final int score;
  final bool favorite;
  final DateTime? addedAt;
  final String mediaType;

  Media({required this.id, required this.score, required this.favorite, required this.addedAt, required this.mediaType});

  factory Media.fromFirestore(String id, Map<String, dynamic> data) {
    return Media(
      id: id,
      score: data['score'] ?? 0,
      favorite: data['favorite'] ?? false,
      addedAt: (data['completedAt'] as Timestamp).toDate(),
      mediaType: (data['mediaType'] ?? 'Unknow'),
    );
  }
}

class AppUser {
  final String name;
  final String username;
  Map<MediaType, Map<String, Media>> media; //all the media the user has consumed
  UserStats stats;



  AppUser({required this.name, required this.username, required this.media}) : stats = getStats(media);

  static UserStats getStats(Map<MediaType, Map<String, Media>> media)
  {
    final ratings = {
      for (var i = 10; i >= 1; i--) i: 0,
    };

    int totalMedia = 0;
    double totalRating = 0;
    List<Media> favs = [];

    for (final mediaByType in media.values)
    {
      for (final item in mediaByType.values)
      {
        ratings[item.score] = (ratings[item.score] ?? 0) + 1;
        totalRating += item.score;
        totalMedia++;
        if(item.favorite) favs.add(item);
      }
    }

    favs.sort((a, b) => b.score.compareTo(a.score)); //orders in descending order

    return UserStats(ratings: ratings, average: (totalRating.toDouble()/totalMedia), totalMedia: totalMedia, favorites: favs);
  }

}

//helper class to store useful information about the users statisitics
class UserStats{
  final Map<int, int> ratings;
  final double average;
  final int totalMedia;
  final List<Media> favorites;
  //final int totalHours;
  //final int top;
  //TODO: para estas comentadas funcionarem é preciso ir buscar infos sobre as lengths ao tmdb
  //TODO: por exemplo, tu numa media vais ter o id, que sera o mesmo id que no tmdb
  //TODO: para isto funcionar entao, e necessario que faças uma media das lengths: for int length => total+=length e depois no final fazes total/totalMedia
  //TODO: isto faz-se na funcao getStats do AppUser
  //TODO: o mesmo para o top, para isso e preciso ir ver todos os user e fazer medias de todos (eu aconselho a droparmos isto pq e mt complexo, mas tu e que sabes)
  //TODO: as horas totais podem ficar tho, isso e mais chill de se fazer
  

  UserStats({required this.ratings, required this.average, required this.totalMedia, required this.favorites});
}