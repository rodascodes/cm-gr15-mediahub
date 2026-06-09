import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_hub/app_util_classes.dart';
import 'package:media_hub/services/auth_service.dart';

class UserServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser> getUser() async {
    final uid = AuthService().currentUid;
    final userDoc = await _db.collection('users').doc(uid).get();
    final data = userDoc.data()!;

    final media = <String, Map<String, MediaStats>>{};

    //inner helper to load one collection (ex: movies)
    Future<Map<String, MediaStats>> loadCollection(String path) async {
      final snapshot = await _db.collection('users').doc(uid).collection(path).get();

      return {
        for (final doc in snapshot.docs)
          doc.id: MediaStats.fromFirestore(int.parse(doc.id), doc.data()),
      };
    }

    final List<String> collections =
    List<String>.from(data['collections'] ?? []);
    print("Collections has: ${collections.length}");

    for(String m in collections)
    {
      print("I am inside the for loop for $m");
      media[m] = await loadCollection(m);
      if(media[m]!.isEmpty) media.remove(m); //i know its not null, look above
    }

    print('MEDIA SIZE IS: ${media.length}');
    
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
    }, SetOptions(merge: true));
  }
}