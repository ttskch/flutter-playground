import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:match/repositories/user_repository.dart';

class Auth {
  Future<void> signupWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          throw InvalidEmailException();
        case 'ERROR_WEAK_PASSWORD':
          throw WeakPasswordException();
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          throw EmailAlreadyInUseException();
        default:
          print(e);
          rethrow;
      }
    }
  }

  Future<LoginResult> loginWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      FirebaseUser user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
              .user;

      return await UserRepository().get(user.uid) == null
          ? LoginResult.SignedUp
          : LoginResult.LoggedIn;
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
        case 'ERROR_USER_NOT_FOUND':
        case 'ERROR_WRONG_PASSWORD':
          return LoginResult.Error;

        default:
          print(e);
          rethrow;
      }
    }
  }

  Future<LoginResult> loginWithTwitter() async {
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
        FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;

        return await UserRepository().get(user.uid) == null
            ? LoginResult.SignedUp
            : LoginResult.LoggedIn;

      case TwitterLoginStatus.cancelledByUser:
        return LoginResult.Canceled;

      case TwitterLoginStatus.error:
      default:
        return LoginResult.Error;
    }
  }

  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  Future<String> getCurrentUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return user != null ? user.uid : null;
  }

  Future<LoginStatus> getLoginStatus() async {
    String userId = await getCurrentUserId();

    if (userId == null) {
      return LoginStatus.Anonymous;
    }

    if (await UserRepository().get(userId) == null) {
      return LoginStatus.SignedUp;
    }

    return LoginStatus.LoggedIn;
  }
}

enum LoginResult {
  SignedUp,
  LoggedIn,
  Canceled,
  Error,
}

enum LoginStatus {
  Anonymous,
  SignedUp,
  LoggedIn,
}

class InvalidEmailException implements Exception {}

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}
