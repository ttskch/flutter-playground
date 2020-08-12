import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match/models/like.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';

typedef LikesListenCallback = void Function(List<Like>);

class LikeRepository {
  final CollectionReference _collection =
      Firestore.instance.collection('likes');

  Future<List<Like>> list(
    User to,
    LikesListenCallback callback,
  ) async {
    final Query query = _collection
        .where('to', isEqualTo: UserRepository().toDocRef(to))
        .orderBy('createdAt');

    query.snapshots().listen((QuerySnapshot ss) async {
      List<DocumentSnapshot> docs = ss.documents;
      final List<Like> likes = await Future.wait(
          docs.map((doc) async => await _fromDoc(doc)).toList());
      // final List<Like> likes = docs.map((doc) => _fromDoc(doc)).toList();
      callback(likes);
    });

    return await Future.wait(
        (await query.getDocuments()).documents.map((doc) async {
      return await _fromDoc(doc);
    }).toList());
  }

  Future<Like> create(User to) async {
    final me = await UserRepository().getMe();

    DocumentReference docRef = await _collection.add({
      'from': UserRepository().toDocRef(me),
      'to': UserRepository().toDocRef(to),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return _fromDoc(await docRef.get());
  }

  Future<Like> _fromDoc(DocumentSnapshot doc) async {
    if (doc.data == null) {
      return null;
    }

    return Like(
      id: doc.documentID,
      from: await UserRepository().fromDocRef(doc.data['from']),
      to: await UserRepository().fromDocRef(doc.data['to']),
      createdAt: (doc.data['createdAt'] ?? Timestamp.now()).toDate(),
    );
  }
}
