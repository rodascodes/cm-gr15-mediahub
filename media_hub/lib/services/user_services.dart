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

    //inner helper to load one collection (ex: movie)
    Future<Map<String, MediaStats>> loadCollection(String path) async {
      final snapshot = await _db.collection('users').doc(uid).collection(path).get();

      return {
        for (final doc in snapshot.docs)
          doc.id: MediaStats.fromFirestore(int.parse(doc.id), doc.data()),
      };
    }

    final List<String> collections =
    List<String>.from(data['collections'] ?? []);

    for(String m in collections)
    {
      media[m] = await loadCollection(m);
      if(media[m]!.isEmpty) media.remove(m); //i know its not null, look above
    }
    
    return AppUser(
      username: data['username'],
      name: data['name'],
      media: media,
    );
  }

  //removed what was here because since the things were all coded the way they were, this just didn't make sense anymore.
  //a refactoring would be perfect for this spaghetti code, but there's not enough time
}