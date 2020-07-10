import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter/flutter_twitter.dart';

class Auth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static final TwitterLogin _twitterLogin = TwitterLogin(
    consumerKey: DotEnv().env['TWITTER_CONSUMER_KEY'],
    consumerSecret: DotEnv().env['TWITTER_CONSUMER_SECRET'],
  );

  static Future<FirebaseUser> loginWithTwitter() async {
    final TwitterLoginResult result = await _twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential credential = TwitterAuthProvider.getCredential(
          authToken: result.session.token,
          authTokenSecret: result.session.secret,
        );
        FirebaseUser firebaseUser =
            (await _firebaseAuth.signInWithCredential(credential)).user;
        return firebaseUser;

      case TwitterLoginStatus.cancelledByUser:
      case TwitterLoginStatus.error:
      default:
        return null;
    }
  }

  static Future<FirebaseUser> getCurrentUser() {
    return _firebaseAuth.currentUser();
  }

  static Future<void> logout() {
    return _firebaseAuth.signOut();
  }
}
