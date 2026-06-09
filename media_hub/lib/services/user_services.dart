import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_hub/app_util_classes.dart';
import 'package:media_hub/services/auth_service.dart';

class UserServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser> getUser() async {
    final uid = AuthService().currentUid;
    final userDoc = await _db.collection('users').doc(uid).get();
    final data = userDoc.data()!;

    final media = <MediaType, Map<String, MediaStats>>{};

    //inner helper to load one collection (ex: movies)
    Future<Map<String, MediaStats>> loadCollection(String path) async {
      final snapshot = await _db.collection('users').doc(uid).collection(path).get();

      return {
        for (final doc in snapshot.docs)
          doc.id: MediaStats.fromFirestore(int.parse(doc.id), doc.data()),
      };
    }

    for(MediaType m in MediaType.values)
    {
      media[m] = await loadCollection(m.name);
      if(media[m]!.isEmpty) media.remove(m); //i know its not null, look above
    }
    
    /*
    media[MediaType.books] = await loadCollection('books');
    media[MediaType.music] = await loadCollection('music');
    media[MediaType.videogames] = await loadCollection('videogames');
    //these are just in case we scale the app further down the line*/
    return AppUser(
      username: data['username'],
      name: data['name'],
      media: media,
    );
  }

  //adds a movie to the users profile document in firestore
  Future<void> addMovie(MediaStats movie) async {
    final uid = AuthService().currentUid;

    await _db.collection('users').doc(uid).update({
      'collections': FieldValue.arrayUnion(['movies']),
    });

    await _db
        .collection('users')
        .doc(uid)
        .collection('movies')
        .doc(movie.id.toString())
        .set({
      'score': movie.score,
      'favorite': movie.favorite,
      'addedAt': Timestamp.now(),
      'mediaType': 'Movies',
    });
  }
}