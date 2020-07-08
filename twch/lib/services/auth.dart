import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter/flutter_twitter.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TwitterLogin _twitterLogin = TwitterLogin(
    consumerKey: DotEnv().env['TWITTER_CONSUMER_KEY'],
    consumerSecret: DotEnv().env['TWITTER_CONSUMER_SECRET'],
  );

  void loginWithTwitter() async {
    final TwitterLoginResult result = await _twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential credential = TwitterAuthProvider.getCredential(
          authToken: result.session.token,
          authTokenSecret: result.session.secret,
        );
        FirebaseUser firebaseUser =
            (await _firebaseAuth.signInWithCredential(credential)).user;
        print(firebaseUser.uid);
        break;
      case TwitterLoginStatus.cancelledByUser:
        break;
      case TwitterLoginStatus.error:
        break;
    }
  }
}
