import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter/flutter_twitter.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TwitterLogin _twitterLogin = TwitterLogin(
    consumerKey: DotEnv().env['TWITTER_CONSUMER_KEY'],
    consumerSecret: DotEnv().env['TWITTER_CONSUMER_SECRET'],
  );

  Future<FirebaseUser> loginWithTwitter() async {
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
        return null;

      case TwitterLoginStatus.error:
        return null;
    }
  }

  Future<FirebaseUser> getCurrentUser() {
    return _firebaseAuth.currentUser();
  }

  Future<void> logout() {
    return _firebaseAuth.signOut();
  }
}
