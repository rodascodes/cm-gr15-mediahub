import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_hub/app_util_classes.dart';
import 'package:media_hub/services/auth_service.dart';

class UserServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //TODO: gotta check this better tomorrow
  Future<AppUser> getUser() async {
    final uid = AuthService().currentUid;
    final userDoc = await _db.collection('users').doc(uid).get();
    final data = userDoc.data()!;

    final media = <MediaType, Map<String, Media>>{};

    //helper to load one collection
    Future<Map<String, Media>> loadCollection(String path) async {
      final snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection(path)
          .get();

      return {
        for (final doc in snapshot.docs)
          doc.id: Media.fromFirestore(doc.id, doc.data()),
      };
    }

    media[MediaType.movies] = await loadCollection('movies');
    /*
    media[MediaType.books] = await loadCollection('books');
    media[MediaType.music] = await loadCollection('music');
    media[MediaType.videogames] = await loadCollection('videogames');
    //these are just in case we scale the app further down the line*/

    return AppUser(
      uid: uid!,
      username: data['username'],
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      media: media,
    );
  }

  Future<void> addMovie(Media movie) async {
    final uid = AuthService().currentUid;
    await _db
        .collection('users')
        .doc(uid)
        .collection('movies')
        .doc(movie.id)
        .set({
      'score': movie.score,
      'favorite': movie.favorite,
      'addedAt': Timestamp.now(),
    });
  }
}