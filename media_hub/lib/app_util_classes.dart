import 'package:cloud_firestore/cloud_firestore.dart';

//all the media types the app may have
enum MediaType {
  movies,
  series,
}

class MediaStats {
  final int id; //id que vem do tmdb
  final int score; 
  final bool favorite;
  final DateTime? addedAt;
  final String mediaType;

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
      addedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      mediaType: (data['mediaType'] ?? 'Unknown'),
      // try common keys for runtime/duration if stored in Firestore
    );
  }
}

class AppUser {
  final String name;
  final String username;
  Map<String, Map<String, MediaStats>> media; //all the media the user has consumed
  UserStats stats;



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
      print("Now going through $mediaByType");
      for (final item in mediaByType.values)
      {
        print("the item is ${item.score}");
        ratings[item.score] = (ratings[item.score] ?? 0) + 1;
        totalRating += item.score;
        totalMedia++;
        if(item.favorite) favs.add(item);
      }
    }

      favs.sort((a, b) => b.score.compareTo(a.score)); //orders in descending order

      // compute duration stats if available
      /*int totalMinutes = 0;
      int knownDurations = 0;
      for (final mediaByType in media.values) {
        for (final item in mediaByType.values) {
          if (item.durationMinutes != null) {
            totalMinutes += item.durationMinutes!;
            knownDurations++;
          }
        }
      }*/

      //final int totalHours = totalMinutes ~/ 60;
      //final double averageLengthMinutes = knownDurations > 0 ? totalMinutes / knownDurations : 0.0; //if exists at least one media with known duration, compute average, otherwise 0

      final double averageRating = totalMedia > 0 ? (totalRating.toDouble() / totalMedia) : 0.0; //if the user has rated at least one media, compute average, otherwise 0

      return UserStats(
        ratings: ratings,
        average: averageRating,
        totalMedia: totalMedia,
        favorites: favs,
        totalHours: 6,
        averageLengthMinutes: 6,
      );
  }

}

//helper class to store useful information about the users statisitics
class UserStats{
  final Map<int, int> ratings;
  final double average;
  final int totalMedia;
  final List<MediaStats> favorites;
  // Total watched/listened/played time in whole hours
  final int totalHours;
  // Average length (minutes) of the media the user has consumed. 0 if unknown.
  final double averageLengthMinutes;

  UserStats({
    required this.ratings,
    required this.average,
    required this.totalMedia,
    required this.favorites,
    required this.totalHours,
    required this.averageLengthMinutes,
  });
}