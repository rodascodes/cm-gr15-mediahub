import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser; //may be useful to keep this stored
  String? get currentUid => currentUser?.uid;

  Future<UserCredential> register(String username, String name, String email, String password) async
  {
    //checks the database to see if there is already any user with that username, if so, launches an exception
    final existingUsers = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).get();
    if(existingUsers.docs.isNotEmpty) throw Exception('Username already taken.');

    //if it reaches here, it means it can go ahead and try to create a User
    UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    //and if it reaches here, it means the user was successfully creates, so it now registers the user info in firestore
    await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      'username': username,
      'name': name.trim().isEmpty ? username : name,
      'email': email,
      'createdAt': Timestamp.now(), //might also be useful to save when a user was created (for displaying account age in profile if it is later desired)
    });

    //TODO: THIS IS JUST FOR TESTING PURPOSES! IT HAS TO BE REMOVED IN THE FUTURE!
    await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).collection('Movies').doc('movieId1').set({
      'score': 5,
      'favorite': true,
      'completedAt': Timestamp.now(),
    });

    return credential;
    //print('email is $email, password is $password');
    //return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> login(String email, String password) async
  {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async{
    await _auth.signOut();
  }
}