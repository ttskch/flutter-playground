import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match/models/user.dart';
import 'package:match/services/auth.dart';
import 'package:match/services/user_criteria.dart';
import 'package:meta/meta.dart';

typedef UsersListenCallback = void Function(List<User>);

class UserRepository {
  final CollectionReference _collection =
      Firestore.instance.collection('users');

  Future<List<User>> list({
    UserCriteria criteria,
  }) async {
    Query query = _collection.orderBy('createdAt');

    if (criteria.gender != null) {
      query = query.where('gender', isEqualTo: criteria.gender.toString());
    }

    // Queryで検索できるのはここまで.

    List<User> users = (await query.getDocuments())
        .documents
        .map((doc) => _fromDoc(doc))
        .toList();

    return criteria.filter(users);
  }

  // TODO: queryでor検索できないので仕方なくコレクション全体をlistenしている...
  void listen({
    @required UsersListenCallback callback,
    UserCriteria criteria,
  }) async {
    _collection.snapshots().listen((qss) async {
      callback(await list(criteria: criteria));
    });
  }

  Future<User> get(String id) async {
    return _fromDoc(await _collection.document(id).get());
  }

  Future<User> getMe() async {
    return get(await Auth().getCurrentUserId());
  }

  Future<User> create({
    String fullName,
    Gender gender,
    int age,
    String selfIntroduction,
    String imageUrl,
  }) async {
    final uid = await Auth().getCurrentUserId();
    DocumentReference docRef = _collection.document(uid);

    await docRef.setData({
      'fullName': fullName,
      'gender': gender.toString(),
      'age': age,
      'selfIntroduction': selfIntroduction,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return _fromDoc(await docRef.get());
  }

  Future<void> update(User user) async {
    if (user.id != await Auth().getCurrentUserId()) {
      throw ArgumentError('他人のユーザー情報は変更できません');
    }

    return _collection.document(user.id).updateData(_toObject(user));
  }

  Future<User> fromDocRef(DocumentReference docRef) async {
    return _fromDoc(await docRef.get());
  }

  DocumentReference toDocRef(User user) {
    return _collection.document(user.id);
  }

  User _fromDoc(DocumentSnapshot doc) {
    if (doc.data == null) {
      return null;
    }

    return User(
      id: doc.documentID,
      fullName: doc.data['fullName'],
      gender: doc.data['gender'] == Gender.Man.toString()
          ? Gender.Man
          : Gender.Woman,
      age: doc.data['age'],
      selfIntroduction: doc.data['selfIntroduction'],
      imageUrl: doc.data['imageUrl'],
      createdAt: (doc.data['createdAt'] ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> _toObject(User user) {
    return {
      'fullName': user.fullName,
      'gender': user.gender.toString(),
      'age': user.age,
      'selfIntroduction': user.selfIntroduction,
      'imageUrl': user.imageUrl,
    };
  }
}
