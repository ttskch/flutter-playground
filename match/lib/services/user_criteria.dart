import 'package:match/models/user.dart';
import 'package:match/repositories/like_repository.dart';
import 'package:match/repositories/user_repository.dart';

class UserCriteria {
  UserCriteria({
    this.gender,
    this.onlyLikers = false,
  });

  Gender gender;
  bool onlyLikers;

  Future<List<User>> filter(List<User> users) async {
    final User me = await UserRepository().getMe();
    List<User> result = [];

    await Future.forEach(users, (user) async {
      if (gender != null && user.gender != gender) {
        return null;
      }

      if (onlyLikers) {
        if (!(await LikeRepository().list(to: me))
            .map((like) => like.from.id)
            .contains(user.id)) {
          return null;
        }
      }

      result.add(user);
    });

    // TODO: onlyLikersの場合はLikeのcreatedAt降順でソートし直す.

    return result;
  }
}
