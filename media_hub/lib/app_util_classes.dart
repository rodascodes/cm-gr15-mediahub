import 'package:cloud_firestore/cloud_firestore.dart';

//This file contains useful classes for various opeartions, but everything here is connected with the User in some way

class MediaStats {
  final int id; //this is the id from tmdb
  final int score; //the score this user has given
  final bool favorite; //wether this work is a favorite or not
  final DateTime? addedAt; //not really used right now, but would be cool in a potential future version
  final String mediaType; //the type of media this work is classified as

  MediaStats({
    required this.id,
    required this.score,
    required this.favorite,
    required this.addedAt,
    required this.mediaType,
  });

  factory MediaStats.fromFirestore(int id, Map<String, dynamic> data) {
    return MediaStats(
      id: id,
      score: data['score'] ?? 0,
      favorite: data['favorite'] ?? false,
      addedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      mediaType: (data['mediaType'] ?? 'Unknown'), //gonna be honest here, if it ever lands on Unknown everything is cooked (I've been there myself)
    );
  }
}

//this class contains the info we need to display on the profile page
class AppUser {
  final String name;
  final String username;
  Map<String, Map<String, MediaStats>> media; //all the media the user has consumed
  UserStats stats; //this are statistics like average score and total media consumed, encapsulated in a dedicated class



  AppUser({required this.name, required this.username, required this.media}) : stats = getStats(media);

  static UserStats getStats(Map<String, Map<String, MediaStats>> media)
  {
    final ratings = {
      for (var i = 10; i >= 1; i--) i: 0,
    };

    int totalMedia = 0;
    double totalRating = 0;
    List<MediaStats> favs = [];

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

      favs.sort((a, b) => b.score.compareTo(a.score)); //orders in descending order, by score, this way 10/10s will apear before lower scores

      List<MediaStats> recentlyRated = List.from(favs);
      recentlyRated.sort((a, b) => b.addedAt!.compareTo(a.addedAt!));
      final cutRecentlyRated = recentlyRated.sublist(0, (recentlyRated.length > 10 ? 10 : recentlyRated.length));

      final double averageRating = totalMedia > 0 ? (totalRating.toDouble() / totalMedia) : 0.0; //if the user has rated at least one media, compute average, otherwise 0

      double roundedAverage = double.parse(averageRating.toStringAsFixed(2));
      
      return UserStats(
        ratings: ratings,
        average: roundedAverage,
        totalMedia: totalMedia,
        favorites: favs,
        recentlyRated: cutRecentlyRated,
      );
  }

}

//helper class to store useful information about the users statisitics
class UserStats{
  final Map<int, int> ratings; //maps <Score, amount> -> <10, 25> means that the user gave 25 pieces of media a 10
  final double average; //the average rating the user has given
  final int totalMedia; //how much media the user has consumed
  final List<MediaStats> favorites; //a list with all of the user's favourite pieces of media
  // Total watched/listened/played time in whole hours
  //final int totalHours; //this had to be ditched
  final List<MediaStats> recentlyRated;

  UserStats({
    required this.ratings,
    required this.average,
    required this.totalMedia,
    required this.favorites,
    required this.recentlyRated,
  });
}