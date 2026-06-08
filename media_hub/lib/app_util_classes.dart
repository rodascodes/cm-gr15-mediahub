import 'package:cloud_firestore/cloud_firestore.dart';

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
  final DateTime addedAt;

  Media({required this.id, required this.score, required this.favorite, required this.addedAt});

  factory Media.fromFirestore(String id, Map<String, dynamic> data) {
    return Media(
      id: id,
      score: data['score'] ?? 0,
      favorite: data['favorite'] ?? false,
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }
}

class AppUser {
  final String uid;
  final String username;
  final String name;
  final DateTime createdAt;

  final Map<MediaType, Map<String, Media>> media;

  AppUser({required this.uid, required this.username, required this.name, required this.createdAt, required this.media});
}