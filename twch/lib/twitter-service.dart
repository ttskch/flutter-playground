import 'package:twitter_api/twitter_api.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TwitterService {
  final _twitterOauth = new twitterApi(
    consumerKey: DotEnv().env['TWITTER_CONSUMER_KEY'],
    consumerSecret: DotEnv().env['TWITTER_CONSUMER_SECRET'],
    token: DotEnv().env['TWITTER_ACCESS_TOKEN'],
    tokenSecret: DotEnv().env['TWITTER_ACCESS_TOKEN_SECRET']
  );

  Future<int> getCurrentFollowerCount(String username) async {

    Future req = _twitterOauth.getTwitterRequest(
      'GET',
      'users/show.json',
      options: {
        'screen_name': username,
      },
    );

    var res = await req;

    if (res.statusCode ~/ 100 != 2) {
      throw new Exception('[${res.statusCode}] ${res.body}');
    }

    return json.decode(res.body)['followers_count'];
  }
}
