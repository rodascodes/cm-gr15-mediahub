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
    //int score = data['score'];
    //bool favorite = data['favorite'];
    //print('everything is fine right before this goofy opeation');
    //DateTime added = (data['addedAt'] as Timestamp).toDate();
    
    //print('data received is: $score, $favorite, $added, and added is ${added.runtimeType}');
    //DateTime addedWorks = (data['completedAt'] as Timestamp).toDate();
    //print('za fixer $addedWorks');
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
  //Map<int, int> ratings; //rating 10 -> x movies; rating 9 -> y movies
  //double average; //average rating can be calculated through the ratings map
  //int hours; //grabs the duration of each movie and sums them all up
  //int top; //what is this user's position in the website (hours spent)
  

  //Map<int, int> ratings;
  //double average;
  //int totalMedia;
  //Map<MediaType, Map<String, Media>> favorites; //the favourite media the user has consumed



  AppUser({required this.name, required this.username, required this.media}) : stats = getStats(media);

  static UserStats getStats(Map<MediaType, Map<String, Media>> media)
  {
    print('I am literally printing right now with: $media');
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

  UserStats({required this.ratings, required this.average, required this.totalMedia, required this.favorites});
}