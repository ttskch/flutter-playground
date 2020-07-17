import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_twitter/flutter_twitter.dart';

class Auth {
  static Future<FirebaseUser> loginWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      return (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } catch (e) {
      print(e);
      print(e.message);
      return null;
    }
  }

  static Future<FirebaseUser> loginWithTwitter() async {
    final TwitterLogin twitter = TwitterLogin(
      consumerKey: DotEnv().env['TWITTER_CONSUMER_KEY'],
      consumerSecret: DotEnv().env['TWITTER_CONSUMER_SECRET'],
    );

    final TwitterLoginResult result = await twitter.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential credential = TwitterAuthProvider.getCredential(
          authToken: result.session.token,
          authTokenSecret: result.session.secret,
        );
        return (await FirebaseAuth.instance.signInWithCredential(credential))
            .user;

      case TwitterLoginStatus.cancelledByUser:
      case TwitterLoginStatus.error:
      default:
        return null;
    }
  }

  static Future<FirebaseUser> getCurrentUser() {
    return FirebaseAuth.instance.currentUser();
  }

  static Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}
