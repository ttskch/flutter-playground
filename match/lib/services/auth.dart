import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static Future<FirebaseUser> loginWithEmailAndPassword({
    String email,
    String password,
  }) async {
    return (await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
  }

  static Future<FirebaseUser> getCurrentUser() {
    return FirebaseAuth.instance.currentUser();
  }

  static Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}
