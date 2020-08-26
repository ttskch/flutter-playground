import 'package:match/models/like.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/like_repository.dart';
import 'package:match/repositories/user_repository.dart';

class UserCriteria {
  UserCriteria({
    this.gender,
    this.minAge,
    this.maxAge,
    this.query,
    this.onlyLikers = false,
    this.onlyMatchers = false,
  });

  Gender gender;
  int minAge;
  int maxAge;
  String query;
  bool onlyLikers;
  bool onlyMatchers;

  Future<List<User>> filter(List<User> users) async {
    final User me = await UserRepository().getMe();
    List<User> result = [];

    await Future.forEach(users, (User user) async {
      if (gender != null && user.gender != gender) {
        return null;
      }

      if (minAge != null && user.age < minAge) {
        return null;
      }

      if (maxAge != null && user.age > maxAge) {
        return null;
      }

      if (query != null && !user.selfIntroduction.contains(query)) {
        return null;
      }

      if (onlyLikers) {
        if (!(await LikeRepository().list(to: me))
            .map((like) => like.from.id)
            .contains(user.id)) {
          return null;
        }
      }

      if (onlyMatchers) {
        final List<Like> matchedLikes1 =
            (await LikeRepository().list(from: me, to: user))
                .where((like) => like.matchedAt != null)
                .toList();
        final List<Like> matchedLikes2 =
            (await LikeRepository().list(from: user, to: me))
                .where((like) => like.matchedAt != null)
                .toList();

        if (matchedLikes1.length < 1 && matchedLikes2.length < 1) {
          return null;
        }
      }

      result.add(user);
    });

    // TODO: onlyMatchersの場合はLikeのmatchedAt順で、onlyLikersの場合はLikeのcreatedAt降順でソートし直す.

    return result;
  }
}
