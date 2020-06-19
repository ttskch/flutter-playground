import 'package:twitter_api/twitter_api.dart';
import 'dart:convert';

class TwitterService {
  final _twitterOauth = new twitterApi(
    consumerKey: '',
    consumerSecret: '',
    token: '',
    tokenSecret: ''
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
