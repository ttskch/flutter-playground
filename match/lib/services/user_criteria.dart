import 'package:match/models/like.dart';
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
    final List<Like> likesToMe = await LikeRepository().list(to: me);

    return users.where((user) {
      if (gender != null && user.gender != gender) {
        return false;
      }

      if (onlyLikers) {
        if (!likesToMe.map((like) => like.from.id).contains(user.id)) {
          return false;
        }

        // TODO: LikeのcreatedAt降順でソートし直す.
      }

      return true;
    }).toList();
  }
}
