import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_twitter/flutter_twitter.dart';

class Auth {
  static Future<FirebaseUser> signupWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      return (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          throw InvalidEmailException();
        case 'ERROR_WEAK_PASSWORD':
          throw WeakPasswordException();
        default:
          print(e);
          rethrow;
      }
    }
  }

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
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          throw InvalidEmailException();
        case 'ERROR_USER_NOT_FOUND':
          throw UserNotFoundExceptioin();
        case 'ERROR_WRONG_PASSWORD':
          throw WrongPasswordException();
        default:
          print(e);
          rethrow;
      }
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

class InvalidEmailException implements Exception {}

class WeakPasswordException implements Exception {}

class UserNotFoundExceptioin implements Exception {}

class WrongPasswordException implements Exception {}
